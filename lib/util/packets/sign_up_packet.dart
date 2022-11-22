import 'package:it_class_frontend/util/packets/packet.dart';

class SignUpPacket extends Packet {
  final String _username;
  final String _password;
  final String _tag;

  SignUpPacket(this._username, this._tag, this._password);

  @override
  Future<Map<String, dynamic>> send({List<String>? content}) async {
    return {
      "id": "ACC",
      "arg": "CRT",
      "arguments": [
        _username,
        _tag,
        _password,
      ]
    };
  }
}
