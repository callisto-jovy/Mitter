import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packet.dart';

class SignInPacket extends Packet {
  final String _password;
  final String _tag;

  SignInPacket(this._tag, this._password);

  @override
  Future<Map<String, dynamic>> send() async => {
        keyId: "ACC",
        keyOperation: "LIN",
        keyArguments: [
          _tag,
          _password,
        ]
      };

  @override
  bool isResponseValid(final PacketCapsule packetCapsule) => packetCapsule.operation == 'COMPLETED';
}
