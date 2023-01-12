import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/util/connection_util.dart';


class MessageToDialog extends StatelessWidget {
  MessageToDialog({Key? key}) : super(key: key);

  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: const Center(child: Text('Message to')),
      actions: [
        IconButton(
            onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.cancel_sharp))
      ],
      actionsAlignment: MainAxisAlignment.start,
      content: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        controller: _tagController,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          prefixIcon: Icon(Icons.tag_rounded),
                          hintText: 'Tag',
                          filled: true,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      TextField(
                        textAlign: TextAlign.left,
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          prefixIcon: const Icon(Icons.message_sharp),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                final String tag = _tagController.text;
                                final String message = _messageController.text;

                                if (message.isNotEmpty && tag.isNotEmpty) {
                                  Get.find<SocketInterface>().sendNewChat(tag, message);
                                }
                              }),
                          hintText: 'Message',
                          filled: true,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
