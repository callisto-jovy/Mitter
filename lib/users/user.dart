import 'dart:convert';
import 'dart:typed_data';

class User {
  final String _username;
  final String _tag;
  Uint8List profile;

  User(this._tag, this._username, this.profile);

  User.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _tag = json['tag'],
        profile = json['pic'] == 'null' ? Uint8List(0) : base64Decode(json['pic']);

  String get tag => _tag;

  String get username => _username;

  String get initials {
    if (username.contains(' ')) {
      final List<String> split = username.split(' ');
      return split.length > 1
          ? (split[0] + split[split.length - 1]).toUpperCase()
          : split[0].toUpperCase();
    } else {
      return username.substring(0, 1).toUpperCase();
    }
  }
}
