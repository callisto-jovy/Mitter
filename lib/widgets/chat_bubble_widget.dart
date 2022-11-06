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
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Material(
              elevation: 20,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: (_message.image != null)
                  ? Image.network(
                      _message.image!,
                      fit: BoxFit.cover,

                    )
                  : Image.asset(
                      'images/user.png',
                      fit: BoxFit.cover,

                    ),
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
