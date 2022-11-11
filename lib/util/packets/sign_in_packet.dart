import 'package:it_class_frontend/util/packets/packet.dart';

class SignInPacket extends Packet {
  final String _password;
  final String _tag;

  SignInPacket(this._tag, this._password);

  @override
  Future<String> send({List<String>? content}) async {
    return 'ACC LIN $_tag $_password';
  }
}
