import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packet.dart';

class SendChatPacket extends Packet {
  final String _content;
  final String? receiver;

  SendChatPacket(this._content, {this.receiver});

  @override
  bool isResponseValid(PacketCapsule packetCapsule) => packetCapsule.operation == 'RCV';

  @override
  Future<Map<String, dynamic>> send() async => {
        'id': 'CHT',
        'arg': 'WRT',
        'arguments': [receiver, _content],
      };
}
