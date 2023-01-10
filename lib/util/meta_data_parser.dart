import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'meta_data_tags.dart';
import 'stream_extension.dart';

Map<String, String>? filterTags(BaseTags baseTags, final Document document) {
  return document.head
      ?.querySelectorAll('meta')
      .where((element) => baseTags.tagValid(element.attributes['property'] ?? ''))
      .toMap<String>(
          //As any attribute w/o a property is already sorted out
          (key) => baseTags.resolveProperty(key.attributes['property']!),
          (value) => value.attributes['content'] ?? '');
}

Future<TagHolder> getMetadata(String url) async {
  final http.Response resp = await http.Client().get(Uri.parse(url));
  final Document document = parse(resp.body);

  //TODO: Special cases with meta data
  final DefaultTags defaultTags = DefaultTags();

  final Map<String, String>? resolved = filterTags(defaultTags, document);
  if (resolved != null) {
    final TagHolder tagHolder =
        TagHolder(resolved['title'], resolved['description'], resolved['image'], resolved['url']);
    return tagHolder;
  }
  return TagHolder(null, null, null, null);
}

const urlPattern =
    r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:,.;]*)?";

bool isValidUrl(final String url) {
  return RegExp(urlPattern, caseSensitive: false).hasMatch(url);
}

String? getDomain(final String url) => Uri.parse(url).host;
