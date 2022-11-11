import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/id_util.dart';
import 'package:it_class_frontend/util/packets/packets.dart';

import '../users/user.dart';
import 'message.dart';

class SocketInterface {
  final List<Message> previousMessages = [];
  final StreamController<List<Message>> publicMessages = StreamController<List<Message>>();

  //TODO: private messages

  final Map<String, Function(dynamic)> callbackRegister = {};

  Socket? _socket;

  SocketInterface(String address) {
    Socket.connect(address, 2000).then((Socket sock) {
      _socket = sock;
      _socket!
          .listen(dataHandler, onError: errorHandler, cancelOnError: false, onDone: doneHandler);
    }).catchError((e) {
      print("Unable to connect: $e");
    });
  }

  Future<void> send(final Packet data, {final Function(dynamic)? whenReceived}) async {
    if (isConnected) {
      data.send().then(
            (value) => _socket!.writeln(value),
          );
      if (whenReceived != null) {
        //Generate random response id
        String stamp = newStamp;
        while (callbackRegister.containsKey(stamp)) {
          stamp = newStamp;
        }
        callbackRegister[stamp] = whenReceived;
      }
    } else {
      previousMessages.add(Message(offlineUser, 'You are offline.'));
      publicMessages.add(previousMessages);
    }
  }

  void dataHandler(Uint8List data) {
    //TODO: Packets (for now all incoming data is handled as messages)
    final String input = String.fromCharCodes(data).trim();
    if (!PacketScanner.isValidForm(input)) {
      //Discard input
      return;
    }
    final PacketParser packetParser = PacketParser(PacketScanner.tokenize(input));
    if (!packetParser.isPacketValid()) {
      return;
    }
    //Call callback to packet
    callbackRegister[packetParser.stamp]?.call(packetParser.arguments);

    //Handle incoming chat
    if (packetParser.id == 'CHT') {
      final String chat = packetParser.nthArgument(0);
      final String from = packetParser.nthArgument(1); //Tag to resolve
      //final User user =

      final String message = packetParser.arguments.sublist(2).join(' ');
      switch (chat) {
        case 'ALL':
          {
            previousMessages
                .add(Message(User(from, 'null', Uint8List.fromList(List.empty())), message));
            publicMessages.add(previousMessages);
            break;
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
