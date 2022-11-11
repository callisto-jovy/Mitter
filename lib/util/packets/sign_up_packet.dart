import 'package:it_class_frontend/util/packets/packet.dart';

class SignUpPacket extends Packet {
  String _username;
  String _password;
  String _tag;

  SignUpPacket(this._username, this._tag, this._password);

  @override
  Future<int> receive(String content) async {
    return int.parse(content);
  }

  @override
  Future<String> send({List<String>? content}) async {
    return 'USR CRT $_username $_tag $_password';
  }
}
