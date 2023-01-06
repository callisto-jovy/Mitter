import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packet.dart';


class ChatGetPacket extends Packet {

  final String _tag;

  ChatGetPacket(this._tag);

  @override
  bool isResponseValid(PacketCapsule packetCapsule) {
    // TODO: implement isResponseValid
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> send() async => {
    keyId: 'CHT',
    keyOperation: 'GET',
    keyArguments: [_tag]
  };
}
