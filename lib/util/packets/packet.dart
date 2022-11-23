import 'package:it_class_frontend/util/encoder_util.dart';

abstract class Packet {
  Future<Map<String, dynamic>> send();

  bool isResponseValid(final PacketCapsule packetCapsule);
}
