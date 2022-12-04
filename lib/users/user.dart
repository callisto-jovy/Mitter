class User {
  final String _username;
  final String _tag;
  final String _profile;

  User(this._username, this._tag, this._profile);

  String get profile => _profile;

  String get tag => _tag;

  String get username => _username;
}
