import 'package:flutter/material.dart';
import 'package:it_class_frontend/constants.dart';

import '../chat/message.dart';

class ChatBubble extends StatelessWidget {
  final Message _message;

  const ChatBubble(this._message, {Key? key}) : super(key: key);

  Widget foreignSender(BuildContext context) => Card(
        elevation: 10,
       // color: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10), child: circleAvatar(_message.sender)),
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
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _message.content,
                maxLines: 1,
                textAlign: TextAlign.end,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(padding: const EdgeInsets.all(10), child: circleAvatar(_message.sender)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: _message.sender.tag == localUser.tag ? ownSender(context) : foreignSender(context));
  }
}
