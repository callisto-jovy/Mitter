import 'package:get/get.dart';
import 'package:it_class_frontend/chat/message.dart';
import 'package:it_class_frontend/util/packets/chat_get_packet.dart';

import '../constants.dart';
import '../users/user.dart';
import '../util/connection_util.dart';
import '../util/packets/user_get_packet.dart';
import 'chat.dart';

class ChatHandler {
  final List<Chat> chats = [];

  void addToChat(final User partner, final Message message) {
    if (chats.any((element) => element.partner.tag == partner.tag)) {
      chats
          .firstWhere((element) => partner.tag == element.partner.tag)
          .messages
          .add(message);
    } else {
      final Chat chat = Chat(partner);
      chat.messages.add(message);
      chats.add(chat);
    }
  }

  Future<void> addPreviousChats(final List<String> tags) async {
    for (final String element in tags) {
      final SocketInterface si = Get.find<SocketInterface>();
      si.send(UserGetPacket(element)).then((value) {
        final User user = User.fromJson(value.nthArgument(0));
        userHandler.addUser(user);

        final Chat chat = Chat(user);
        chats.add(chat);
        Get.find<SocketInterface>().chatController.add(chats);
      }).then((value) => si.send(ChatGetPacket(element)));
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
