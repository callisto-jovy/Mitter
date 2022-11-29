import 'package:it_class_frontend/users/user.dart';
import 'package:it_class_frontend/util/message.dart';

class Chat {
  final User _partner;
  final List<Message> messages = [];

  Chat(this._partner);

  String get chatName => _partner.username;
  User get partner => _partner;
}
