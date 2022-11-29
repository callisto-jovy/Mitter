import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packet.dart';

class UserGetPacket extends Packet {
  final String _tag;

  UserGetPacket(this._tag);

  @override
  bool isResponseValid(PacketCapsule packetCapsule) {
    // TODO: implement isResponseValid
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> send() async => {
        'id': 'USR',
        'arg': 'GET',
        'arguments': [_tag]
      };
}
