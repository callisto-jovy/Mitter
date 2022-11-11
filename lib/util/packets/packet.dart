class Packet {
  Future<dynamic> receive(String content) async {
    return Future.error('Not implemented: receive method');
  }

  Future<String> send({List<String>? content}) async {
    return Future.error('Not implemented: send method');
  }
}
