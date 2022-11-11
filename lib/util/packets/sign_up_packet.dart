import 'package:it_class_frontend/util/packets/packet.dart';

class SignUpPacket extends Packet {
  final String _username;
  final String _password;
  final String _tag;

  SignUpPacket(this._username, this._tag, this._password);

  @override
  Future<String> send({List<String>? content}) async {
    return 'USR CRT $_username $_tag $_password';
  }
}
