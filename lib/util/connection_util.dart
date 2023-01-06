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
      _socket!
          .listen(dataHandler, onError: errorHandler, cancelOnError: false, onDone: doneHandler);
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

  void dataHandler(List<int> data) {
    final List<String> input = utf8.decode(data).trim().split("\n");
    //Idk why this is necessary...
    for (String value in input) {
      if (!PacketScanner.isValidForm(value)) {
        //Discard input
        return;
      }

      print(value);

      final PacketCapsule packetParser = PacketCapsule(jsonDecode(value));
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
        print(errorType.description);
        return;
      }

      //Handle incoming chat
      if (packetParser.id == 'CHT') {
        if (packetParser.operation == 'REC') {
          final String message = packetParser.nthArgument(0);
          final String sender = packetParser.nthArgument(1);
          final String receiver = packetParser.nthArgument(2);

          final String tag = sender == localUser.tag ? receiver : sender;

          //The user is already known..
          if (userHandler.containsTag(tag)) {
            //Use the existing data --> Less traffic
            final User resolved = userHandler.getUser(tag);

            chatHandler.addToChat(Message(resolved, message));
            //Update all the active chats
            chatController.add(chatHandler.chats);
          } else {
            send(UserGetPacket(tag))
                .then((value) => User.fromJson(value.nthArgument(0)))
                .then((value) {
              userHandler.addUser(value);
              chatHandler.addToChat(Message(value, message));
              chatController.add(chatHandler.chats);
            });
          }
        }
      }
    }
  }

  /*
  Future<User> resolveUnknownUser(final String userTag) async {
    send(UserGetPacket(userTag), whenReceived: (p0) {
      return
    },);
  }

   */

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
        print(value);
        final User resolved =
            User(value.nthArgument(0), value.nthArgument(1), value.nthArgument(2));
        userHandler.addUser(resolved);

        final Chat chat = Chat(resolved);
        chat.messages.add(msg);
        chatHandler.chats.add(chat);
        chatController.add(chatHandler.chats);
      });
    }
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
    _socket!.close();
  }

  void doneHandler() {
    if (isConnected) _socket!.destroy();
  }

  bool get isConnected => _socket != null;
}
