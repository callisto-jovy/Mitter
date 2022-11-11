import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:it_class_frontend/util/packets/packet.dart';

import 'message.dart';

class SocketInterface {
  final List<Message> previousMessages = [];
  final StreamController<List<Message>> messages = StreamController<List<Message>>();
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

  Future<void> send(final Packet data) async {
    if (isConnected)
      data.send().then(
            (value) => _socket!.writeln(value),
          );
    else {
      data.send().then((value) {
        previousMessages.add(Message(value));
        messages.add(previousMessages);
      });
    }
  }

  void dataHandler(Uint8List data) {
    //TODO: Packets (for now all incoming data is handled as messages)
    previousMessages.add(Message(String.fromCharCodes(data)));
    messages.add(previousMessages);
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
