abstract class BaseTags {
  final String title;
  final String description;
  final String image;
  final String url;

  BaseTags(this.title, this.description, this.image, this.url);

  List<String> get toList => [title, description, image, url];

  String resolveProperty(final String property);

  bool tagValid(final String property) {
    return property == title || property == description || property == image || property == url;
  }
}

class DefaultTags extends BaseTags {
  DefaultTags() : super('og:title', 'og:description', 'og:image', 'og:url');

  ///Really ugly, but works.
  @override
  String resolveProperty(final String property) {
    switch (property) {
      case 'og:title':
        return 'title';
      case 'og:description':
        return 'description';
      case 'og:image':
        return 'image';
      case 'og:url':
        return 'url';
    }
    return '';
  }
}

class TagHolder {
  final String? title;
  final String? description;
  final String? image;
  final String? url;

  TagHolder(this.title, this.description, this.image, this.url);
}
