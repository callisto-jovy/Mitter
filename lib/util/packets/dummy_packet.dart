import 'package:it_class_frontend/util/packets/packet.dart';

class DummyPacket extends Packet {
  @override
  Future<String> send({List<String>? content}) async {
    return 'Dummy';
  }
}
