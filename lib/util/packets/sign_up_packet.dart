import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packet.dart';

class SignUpPacket extends Packet {
  final String _username;
  final String _password;
  final String _tag;

  SignUpPacket(this._username, this._tag, this._password);

  @override
  Future<Map<String, dynamic>> send() async => {
        keyId: "ACC",
        keyOperation: "CRT",
        keyArguments: [
          _username,
          _tag,
          _password,
        ]
      };

  @override
  bool isResponseValid(PacketCapsule packetCapsule) => packetCapsule.operation == 'CREATED';
}
