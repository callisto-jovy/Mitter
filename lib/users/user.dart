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
        profile = base64Decode(json['pic']);

  String get tag => _tag;

  String get username => _username;

  String get initials => username.contains(' ') ? username.split(' ').getRange(0, 2).map((e) => e[0]).join() : username.substring(0, 1).toUpperCase();
}
