import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/util/packets/send_chat_packet.dart';
import 'package:it_class_frontend/widgets/chat_bubble_widget.dart';
import 'package:it_class_frontend/widgets/message_send_text_field.dart';

class MitterMain extends StatefulWidget {
  const MitterMain({Key? key}) : super(key: key);

  @override
  State<MitterMain> createState() => _MitterMainState();
}

class _MitterMainState extends State<MitterMain> {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            'Mitter',
            textAlign: TextAlign.start,
            style: loginTitleStyle(size),
          ),
        ),
        //Messages
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
                  itemExtent: 75,
                  reverse: true,
                  controller: _scrollController,
                  children: snapshot.data!.map((e) => ChatBubble(e)).toList(),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          stream: Get.find<SocketInterface>().publicMessages.stream,
        ),
        SizedBox(
          height: size.height / 1.5,
        ),
        MessageSendField((String text) =>
            Get.find<SocketInterface>().send(SendChatPacket(text, receiver: '000000'))),
      ],
    );
  }
}
