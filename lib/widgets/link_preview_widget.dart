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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                snapshot.data!.image != null
                    ? CachedNetworkImage(
                        imageUrl: snapshot.data!.image!,
                        maxHeightDiskCache: 500,
                        maxWidthDiskCache: 500,
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
                const VerticalDivider(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data!.title ?? 'No title.',
                          maxLines: 2,
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        snapshot.data!.description ?? 'No description.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 5,
                        softWrap: true,
                      )
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
