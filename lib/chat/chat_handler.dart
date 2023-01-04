import 'package:get/get.dart';
import 'package:it_class_frontend/chat/message.dart';
import 'package:it_class_frontend/util/packets/chat_get_packet.dart';

import '../constants.dart';
import '../users/user.dart';
import '../util/connection_util.dart';
import '../util/encoder_util.dart';
import '../util/packets/user_get_packet.dart';
import 'chat.dart';

class ChatHandler {
  final List<Chat> chats = [];

  void addToChat(final Message message) {
    if (chats.any((element) => element.partner.tag == message.sender.tag)) {
      chats
          .firstWhere((element) => message.sender.tag == element.partner.tag)
          .messages
          .add(message);
    } else {
      final Chat chat = Chat(message.sender);
      chat.messages.add(message);
      chats.add(chat);
    }
  }

  void addPreviousChats(final List<String> tags) {
    for (final String element in tags) {
      Get.find<SocketInterface>().send(UserGetPacket(element), whenReceived: (PacketCapsule value) {
        final User user = User(value.nthArgument(0), value.nthArgument(1), value.nthArgument(2));
        userHandler.addUser(user);

        final Chat chat = Chat(user);
        chats.add(chat);
        Get.find<SocketInterface>().chatController.add(chats);

      });

      //Request chat content between users:
      Get.find<SocketInterface>().send(ChatGetPacket(element));
    }
  }

  void addOwn(final String receiver, final String message) {
    chats
        .where((element) => element.partner.tag == receiver)
        .first
        .messages
        .add(Message(localUser, message));
  }
}
