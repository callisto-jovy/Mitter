import 'package:it_class_frontend/util/packets/packet.dart';

class SignInPacket extends Packet {
  final String _password;
  final String _tag;

  SignInPacket(this._tag, this._password);

  @override
  Future<Map<String, dynamic>> send({List<String>? content}) async {
    return {
      'id': "ACC",
      "arg": "LIN",
      "arguments": [
        _tag,
        _password,
      ]
    };
  }
}
