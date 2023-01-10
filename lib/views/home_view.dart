import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/widgets/chat_bubble_widget.dart';
import 'package:it_class_frontend/widgets/message_to_dialog.dart';

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
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: ElevatedButton.icon(
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
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              icon: const Icon(Icons.search_sharp),
              label: const Text("Add friend"),
            ),
          ),
        )
      ],
    );
  }
}
