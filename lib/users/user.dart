import 'dart:typed_data';

class User {
  final String _username;
  final String _tag;
  final Uint8List _profile;

  User(this._username, this._tag, this._profile);

  Uint8List get profile => _profile;

  String get tag => _tag;

  String get username => _username;
}
