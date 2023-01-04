import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packets.dart';
import 'package:it_class_frontend/util/packets/user_get_packet.dart';
import 'package:rxdart/rxdart.dart';

import '../chat/chat.dart';
import '../users/user.dart';
import 'error_resolver.dart';
import '../chat/message.dart';

class SocketInterface {
  /// A list of all the previously incoming messages. Used to update the stream, as the stream only takes in the newest element, we need a list to keep track of every
  /// previous message
  final List<Message> previousMessages = [];

  ///StreamController used to update all the publicly available messages
  final StreamController<List<Message>> publicMessages = BehaviorSubject();

  ///StreamController, in which errors may be sent, to display them to the user in the form of an alert bubble
  final StreamController<String> errors = StreamController<String>();

  ///StreamController responsible for all chats
  final StreamController<List<Chat>> chatController = BehaviorSubject();

  //TODO: private messages
  ///Map with an id as the key and a function, which takes in a PacketCapsule-Object, as it's value.
  ///The map is used to store the packet's callbacks. If i.e. the server directly responds to a sent packet, the referral can be identified.
  final Map<String, Function(PacketCapsule)> callbackRegister = {};

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

  ///Method to send any packet and optionally add a callback, when a packet with the same identifier is received
  Future<void> send(final Packet data, {final Function(PacketCapsule)? whenReceived}) async {
    if (isConnected) {
      data.send().then((value) => PacketFormatter.format(value)).then((value) {
        if (whenReceived != null) callbackRegister[value[1]] = whenReceived;
        _socket!.writeln(value[0]);
      });
    } else {
      //Display an error to the user.
      errors.add('You are offline');
    }
  }

  void dataHandler(List<int> data) {
    final String input = utf8.decode(data).trim();
    if (!PacketScanner.isValidForm(input)) {
      //Discard input
      return;
    }

    print(input);

    final PacketCapsule packetParser = PacketCapsule(PacketScanner.tokenize(input));
    if (!packetParser.isPacketValid()) {
      return;
    }

    //Call callback to packet
    callbackRegister[packetParser.stamp]?.call(packetParser);
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
        final String from = packetParser.nthArgument(1);
        final String message = packetParser.nthArgument(0);

        if(userHandler.containsTag(from)) {
          //Use the existing data --> Less traffic
          final User resolved = userHandler.getUser(from);
          chatHandler.addToChat(Message(resolved, message));
          //Update all the active chats
          chatController.add(chatHandler.chats);
        } else {
          //Resolve the user
          send(UserGetPacket(from), whenReceived: (p0) {
            final User resolved = User(p0.nthArgument(0), p0.nthArgument(1), p0.nthArgument(2));
            userHandler.addUser(resolved);

            chatHandler.addToChat(Message(resolved, message));
            //Update all the active chats
            chatController.add(chatHandler.chats);
          });
        }
      }
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
