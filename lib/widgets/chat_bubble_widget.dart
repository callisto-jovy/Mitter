import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:it_class_frontend/constants.dart';

import '../chat/message.dart';

class ChatBubble extends StatelessWidget {
  final Message _message;

  const ChatBubble(this._message, {Key? key}) : super(key: key);

  Widget foreignSender(BuildContext context) => Card(
        elevation: 10,
        color: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Material(
                elevation: 20,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: (_message.sender.profile != "null")
                    ? Image.memory(
                        base64Decode(_message.sender.profile),
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.supervised_user_circle_rounded),
              ),
            ),
            Expanded(
              child: Text(
                _message.content,
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  Widget ownSender(BuildContext context) => Card(
        elevation: 10,
        color: Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15))),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Material(
                elevation: 20,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: (localUser.profile != "null")
                    ? Image.memory(
                        base64Decode(localUser.profile),
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.supervised_user_circle_rounded),
              ),
            ),
            Expanded(
              child: Text(
                _message.content,
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return _message.sender.tag == localUser.tag ? ownSender(context) : foreignSender(context);
  }
}
