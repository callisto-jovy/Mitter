import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/message.dart';

import 'chat.dart';

class ChatHandler {
  final List<Chat> chats = [];

  void addToChat(final Message message) {
    chats.where((element) => message.sender.tag == element.partner.tag).first.messages.add(message);
  }

  void addOwn(final String receiver, final String message) {
    chats
        .where((element) => element.partner.tag == receiver)
        .first
        .messages
        .add(Message(localUser, message));
  }
}
