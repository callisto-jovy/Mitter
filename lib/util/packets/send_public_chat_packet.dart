import 'package:it_class_frontend/util/packets/packet.dart';

import '../encoder_util.dart';

class SendPublicChatPacket extends Packet {
  final String _content;

  SendPublicChatPacket(this._content);

  @override
  bool isResponseValid(PacketCapsule packetCapsule) => packetCapsule.operation == 'RCV';

  @override
  Future<Map<String, dynamic>> send() async => {
    keyId: 'PUB',
    keyOperation: 'WRT',
    keyArguments: [_content],
  };
}
