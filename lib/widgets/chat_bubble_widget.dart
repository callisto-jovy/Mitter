import 'package:flutter/material.dart';
import 'package:it_class_frontend/constants.dart';

import '../util/message.dart';

class ChatBubble extends StatelessWidget {
  final Message _message;

  const ChatBubble(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 10,
      color: Theme.of(context).colorScheme.secondary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Row(
        children: [
          Material(
            elevation: 20,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
            clipBehavior: Clip.antiAlias,
            child: (_message.image != null)
                ? Image.network(
                    _message.image!,
                    fit: BoxFit.fill,
                    height: size.height * 0.02,
                    width: size.width * 0.02,
                  )
                : Image.asset(
                    'user',
                    width: size.width * 0.02,
                    height: size.height * 0.02,
                  ),
          ),
          Expanded(
            child: Text(
              _message.content,
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: textChatBubbleStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
