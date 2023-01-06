class User {
  final String _username;
  final String _tag;
  final String _profile;

  User(this._tag, this._username, this._profile);

  User.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _tag = json['tag'],
        _profile = json['pic'];

  String get profile => _profile;

  String get tag => _tag;

  String get username => _username;
}
