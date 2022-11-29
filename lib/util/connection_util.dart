import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packets.dart';
import 'package:it_class_frontend/util/packets/user_get_packet.dart';

import '../users/user.dart';
import 'chat.dart';
import 'error_resolver.dart';
import 'message.dart';

class SocketInterface {
  final List<Message> previousMessages = [];
  final StreamController<List<Message>> publicMessages = StreamController<List<Message>>();
  final StreamController<String> errors = StreamController<String>();
  final StreamController<Chat> chatController = StreamController<Chat>();

  //TODO: private messages

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

  Future<void> send(final Packet data, {final Function(PacketCapsule)? whenReceived}) async {
    if (isConnected) {
      data.send().then((value) => PacketFormatter.format(value)).then((value) {
        if (whenReceived != null) callbackRegister[value[1]] = whenReceived;
        _socket!.writeln(value[0]);
      });
    } else {
      previousMessages.add(Message(offlineUser, 'You are offline.'));
      publicMessages.add(previousMessages);
    }
  }

  void dataHandler(Uint8List data) {
    final String input = String.fromCharCodes(data).trim();
    if (!PacketScanner.isValidForm(input)) {
      //Discard input
      return;
    }
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
        final String chat = packetParser.nthArgument(0);
        send(UserGetPacket(from), whenReceived: (p0) {
          final User resolved =
              User(p0.arguments[0], p0.arguments[1], base64Decode(p0.arguments[2]));

          previousMessages.add(Message(resolved, chat));
          publicMessages.add(previousMessages);
        });
      }

      //Resolve tag
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
