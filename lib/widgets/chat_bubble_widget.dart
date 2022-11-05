import 'package:flutter/material.dart';
import 'package:it_class_frontend/constants.dart';

import '../util/message.dart';

class ChatBubble extends StatelessWidget {
  final Message _message;

  const ChatBubble(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5)),
          shape: BoxShape.rectangle,
          color: Theme.of(context).colorScheme.secondary),
      child: Text(
        _message.content,
        textAlign: TextAlign.center,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: textChatBubbleStyle(),
      ),
    );
  }
}
