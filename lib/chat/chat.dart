import 'package:it_class_frontend/users/user.dart';
import 'package:it_class_frontend/chat/message.dart';

class Chat {
  final User _partner;
  final List<Message> messages = [];

  Chat(this._partner);

  String get chatName => _partner.username;

  String get partnerTag => _partner.tag;

  User get partner => _partner;




}
