import 'package:it_class_frontend/util/packets/packet.dart';

class SignInPacket extends Packet {
  String _password;
  String _tag;

  SignInPacket(this._tag, this._password);

  @override
  Future<Map<String, dynamic>> receive(String content) async {


    return int.parse(content);
  }

  @override
  Future<String> send({List<String>? content}) async {
    return 'ACC LIN $_tag $_password';
  }
}
