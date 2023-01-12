import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/util/packets/send_public_chat_packet.dart';
import 'package:it_class_frontend/widgets/chat_bubble_widget.dart';
import 'package:it_class_frontend/widgets/message_send_text_field.dart';
import 'package:it_class_frontend/widgets/message_to_dialog.dart';
import 'package:it_class_frontend/widgets/public_message_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
                height: size.height / 1.3,
                width: size.width / 1.2,
                child: ListView(
                  shrinkWrap: true,
                  controller: _scrollController,
                  children: snapshot.data!.map((e) => PublicMessageCard(e)).toList(),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          stream: Get.find<SocketInterface>().publicMessagesControlledStream.stream,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 5,
                child: MessageSendField(
                    (p0) => Get.find<SocketInterface>().send(SendPublicChatPacket(p0))),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 10, bottom: 10, left: 10),

                  child: FloatingActionButton(
                    onPressed: () => showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: '',
                      barrierColor: Colors.black38,
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (ctx, anim1, anim2) => MessageToDialog(),
                      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                        child: FadeTransition(
                          opacity: anim1,
                          child: child,
                        ),
                      ),
                      context: context,
                    ),
                    child: const Icon(Icons.message_sharp),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
