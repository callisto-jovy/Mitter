import 'package:it_class_frontend/util/packets/packet.dart';

import '../encoder_util.dart';

class ProfilePacket extends Packet {
  final String _base64;

  ProfilePacket(this._base64);

  @override
  bool isResponseValid(PacketCapsule packetCapsule) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> send() async => {
    keyId: 'ACC',
    keyOperation: 'PROFILE',
    keyArguments: [_base64]
  };
}
