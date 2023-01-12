import 'package:flutter/material.dart';
import 'package:it_class_frontend/util/stream_extension.dart';
import 'package:it_class_frontend/util/string_validator.dart';

import '../chat/message.dart';
import '../constants.dart';
import '../util/meta_data_parser.dart';
import 'link_preview_widget.dart';

class PublicMessageCard extends StatelessWidget {
  final Message _message;

  const PublicMessageCard(this._message, {Key? key}) : super(key: key);

  Widget linkPreview(String link) => Container(
        padding: const EdgeInsets.only(left: 5, bottom: 5),
        child: LinkPreviewWidget(
          link,
        ),
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

  Widget messageCard(BuildContext context) => Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(padding: const EdgeInsets.all(10), child: circleAvatar(_message.sender)),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                      text: '${_message.sender.tag}\n',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                            text: _message.content, style: Theme.of(context).textTheme.bodyMedium)
                      ]),
                ),
              ),
            ],
          ),
          isValidUrl(_message.content) ? linkPreview(_message.content) : Container()
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 30, right: 30), child: messageCard(context));
  }
}
