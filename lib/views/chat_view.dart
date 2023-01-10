import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/chat/chat.dart';
import 'package:it_class_frontend/chat/message.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/widgets/chat_bubble_widget.dart';

import '../constants.dart';
import '../util/packets/send_chat_packet.dart';
import '../widgets/message_send_text_field.dart';

class ChatView extends StatefulWidget {
  final int _chatIndex;

  const ChatView(this._chatIndex, {Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                }
              });
              return SizedBox(
                height: size.height / 1.15,
                width: size.width / 1.2,
                child: ListView(
                  shrinkWrap: true,
                  reverse: false,
                  controller: _scrollController,
                  children:
                      snapshot.data![widget._chatIndex].messages.map((e) => ChatBubble(e)).toList(),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          stream: Get.find<SocketInterface>().chatController.stream,
        ),
        Expanded(
          child: MessageSendField((String text) {
            final Chat chat = chatHandler.chats[widget._chatIndex];

            Get.find<SocketInterface>()
                .send(SendChatPacket(text, receiver: chat.partnerTag))
                .then((value) => value.operation == 'SUCCESS' && chat.partnerTag != localUser.tag)
                .then((value) =>
                    value ? chat.messages.add(Message(localUser, text)) : null) //Append the message
                .then((value) => Get.find<SocketInterface>()
                    .chatController
                    .add(chatHandler.chats)); //Update the chats.
          }),
        ),
      ],
    );
  }
}
