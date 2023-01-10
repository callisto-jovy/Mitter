import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:it_class_frontend/util/meta_data_tags.dart';

import '../util/meta_data_parser.dart';

class LinkPreviewWidget extends StatefulWidget {
  const LinkPreviewWidget(this._url, {Key? key}) : super(key: key);

  final String _url;

  @override
  State<LinkPreviewWidget> createState() => _LinkPreviewWidgetState();
}

class _LinkPreviewWidgetState extends State<LinkPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<TagHolder>(
        stream: getMetadata(widget._url).asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [
                snapshot.data!.image != null
                    ? CachedNetworkImage(
                        imageUrl: snapshot.data!.image!,
                        maxHeightDiskCache: 300,
                        maxWidthDiskCache: 300,
                        imageBuilder: (context, imageProvider) => (Container(
                          width: size.width * 0.2,
                          height: size.height * 0.2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                          ),
                        )),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                    : Container(),
                Expanded(
                  child: Text(snapshot.data!.title ?? 'No title.', textAlign: TextAlign.left),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
