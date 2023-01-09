import 'package:flutter/material.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/stream_extension.dart';
import 'package:it_class_frontend/util/string_validator.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

import '../chat/message.dart';

class ChatBubble extends StatelessWidget {
  final Message _message;

  const ChatBubble(this._message, {Key? key}) : super(key: key);

  Widget linkPreview(String link) => LinkPreviewGenerator(
        link: link,
        linkPreviewStyle: LinkPreviewStyle.small,
        showGraphic: false,
      );

  //TODO: Optimize
  Widget richText({required TextAlign textAlign}) => RichText(
    textAlign: textAlign,
      text: TextSpan(
          children: _message.content
              .split(r'\s+')
              .split((element) => element.isValidUrl)
              .map((e) => TextSpan(
                  children: e
                      .map((e) => TextSpan(
                          text: e, style: TextStyle(color: e.isValidUrl ? Colors.blueGrey : null)))
                      .toList()))
              .toList()));

  Widget messageText({TextAlign? textAlign}) => Expanded(
        child: Text(
          _message.content,
          textAlign: textAlign,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: _message.content.isValidUrl ? Colors.blueAccent : null),
        ),
      );

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
            Container(padding: const EdgeInsets.all(10), child: circleAvatar(_message.sender)),
            messageText(textAlign: TextAlign.start),
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
            richText(textAlign: TextAlign.end),
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
