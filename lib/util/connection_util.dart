import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'message.dart';

class SocketInterface {
  final List<Message> previousMessages = [];
  final StreamController<List<Message>> messages = StreamController<List<Message>>();

  SocketInterface(String address) {
    Socket.connect(address, 2000).then((Socket sock) {
      _socket = sock;
      _socket.listen(dataHandler, onError: errorHandler, cancelOnError: false, onDone: doneHandler);
    }).catchError((e) {
      print("Unable to connect: $e");
    });
  }

  late final Socket _socket;

  Future<void> send(String data) async {
    if (_socket != null) _socket.write(data);
  }

  void dataHandler(Uint8List data) {
    //TODO: Packets (for now all incoming data is handled as messages)
    previousMessages.add(Message(String.fromCharCodes(data)));
    messages.add(previousMessages);
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
    if (_socket != null) _socket.close();
  }

  void doneHandler() {
    if (_socket != null) _socket.destroy();
  }
}
