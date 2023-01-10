import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packets.dart';
import 'package:it_class_frontend/util/packets/send_chat_packet.dart';
import 'package:it_class_frontend/util/packets/user_get_packet.dart';
import 'package:rxdart/rxdart.dart';

import '../chat/chat.dart';
import '../chat/message.dart';
import '../users/user.dart';
import 'error_resolver.dart';

class SocketInterface {
  /// A list of all the previously incoming messages. Used to update the stream, as the stream only takes in the newest element, we need a list to keep track of every
  /// previous message
  final List<Message> previousMessages = [];

  ///StreamController used to update all the publicly available messages
  final StreamController<List<Message>> publicMessages = BehaviorSubject();

  ///StreamController, in which errors may be sent, to display them to the user in the form of an alert bubble
  final StreamController<String> errors = BehaviorSubject<String>();

  ///StreamController responsible for all chats
  final StreamController<List<Chat>> chatController = BehaviorSubject();

  ///Map with an id as the key and a function, which takes in a PacketCapsule-Object, as it's value.
  ///The map is used to store the packet's callbacks. If i.e. the server directly responds to a sent packet, the referral can be identified.
  final Map<String, Completer> callbackRegister = {};

  Socket? _socket;

  SocketInterface(String address) {
    Socket.connect(address, 2000).then((Socket sock) {
      _socket = sock;

      // _socket!.listen(dataHandler, onError: errorHandler, cancelOnError: false, onDone: doneHandler);
      listen();
    }).catchError((e) {
      print("Unable to connect: $e");
      _socket = null;
    });
  }

  ///Method to send any packet. [Returns] a future that is completed when a response to the exact packet is sent.
  Future<PacketCapsule> send(final Packet data) async {
    if (!isConnected) {
      errors.add('You are offline.');
      return Future.error('The socket is not connected!');
    }
    final Completer<PacketCapsule> completer = Completer();
    data.send().then((value) => PacketFormatter.format(value)).then((value) {
      callbackRegister[value[1]] = completer;
      _socket!.writeln(value[0]);
    });
    return completer.future;
  }

  void listen() async {
    const terminator = '___\n';
    final List<int> terminatorSequence = utf8.encode(terminator);

    final List<int> bytesRead = [];

    await for (List<int> packet in _socket!) {
      //Read bytes until terminator
      final Iterator<int> iter = packet.iterator;
      int terminatorIndex = 0;
      //Move through the bytes, until the terminator sequence is found
      while (iter.moveNext()) {
        final int curr = iter.current;
        //If the the current byte matches the corresponding byte (trying to find a sequence), move to the next index
        if (terminatorSequence[terminatorIndex] == curr) {
          terminatorIndex++; //move to the next index
        } else {
          terminatorIndex = 0; //Reset the index, no sequence found
        }

        bytesRead.add(curr);
        //the terminator sequence way fully found, the packet is complete
        if (terminatorIndex == terminatorSequence.length) {
          //packet terminated
          final String message =
              utf8.decode(bytesRead.sublist(0, bytesRead.length - terminatorSequence.length));
          handleData(message); //Send off to handle the data
          bytesRead.clear(); //Clear the read bytes, a new packet has to be read from the buffer(s)
          terminatorIndex = 0; //Reset the terminator index
        }
      }
    }
  }

  void handleData(String input) {
    if (!PacketScanner.isValidForm(input)) {
      //Discard input
      return;
    }

    final PacketCapsule packetParser = PacketCapsule(jsonDecode(input));
    if (!packetParser.isPacketValid()) {
      return;
    }

    if (callbackRegister.containsKey(packetParser.stamp)) {
      //Complete the future.
      callbackRegister[packetParser.stamp]?.complete(packetParser);
      callbackRegister.remove(packetParser.stamp);
    }

    //Catch error
    if (packetParser.id == 'ERR') {
      //Resolve error from its code
      final int errorCode = int.parse(packetParser.operation);
      final ErrorType errorType =
          ErrorType.values.where((element) => element.code == errorCode).first;
      errors.add(errorType.description);
      return;
    }

    //Handle incoming chat
    if (packetParser.id == 'CHT') {
      if (packetParser.operation == 'REC') {
        final String message = packetParser.nthArgument(0);
        final String sender = packetParser.nthArgument(1);
        final String receiver = packetParser.nthArgument(2);

        final String partnerTag = sender == localUser.tag ? receiver : sender;

        if (userHandler.containsTag(partnerTag)) {
          //Use the existing data --> Less traffic
          final User partnerUser = userHandler.getUser(partnerTag);
          final User senderUser = sender == localUser.tag ? localUser : partnerUser;

          chatHandler.addToChat(partnerUser, Message(senderUser, message));
          //Update all the active chat
          chatController.add(chatHandler.chats);
        } else {
          //Resolve the tag and continue
          send(UserGetPacket(partnerTag))
              .then((value) => User.fromJson(value.nthArgument(0)))
              .then((partnerUser) {
            userHandler.addUser(partnerUser);
            final User senderUser = sender == localUser.tag ? localUser : partnerUser;
            chatHandler.addToChat(partnerUser, Message(senderUser, message));
            chatController.add(chatHandler.chats);
          });
        }
      }
    }
  }

  Future<User> resolveUnknownUser(final String userTag) async {
    return send(UserGetPacket(userTag)).then((value) => User.fromJson(value.nthArgument(0)));
  }

  Future<void> sendUserChat(final String receiver, final String message) async {
    Message? msg = await send(SendChatPacket(message, receiver: receiver)).then((value) {
      if (value.operation == 'SUCCESS' && receiver != localUser.tag) {
        //Open a new chat, request user information...
        return Message(localUser, message);
      }
    }).onError((error, stackTrace) {
      errors.add('Error occurred in future: ${error ?? 'unknown'}');
      return null;
    });

    if (msg != null) {
      send(UserGetPacket(receiver)).then((value) {
        final User resolved = User.fromJson(value.nthArgument(0));
        userHandler.addUser(resolved);

        final Chat chat = Chat(resolved);
        chat.messages.add(msg);
        chatHandler.chats.add(chat);
        chatController.add(chatHandler.chats);
      });
    }
  }

  void errorHandler(error, StackTrace trace) {
    errors.add(error);
    _socket!.close();
  }

  void doneHandler() {
    if (isConnected) _socket!.destroy();
  }

  bool get isConnected => _socket != null;
}
