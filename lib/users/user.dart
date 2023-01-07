class User {
  final String _username;
  final String _tag;
  String profile;

  User(this._tag, this._username, this.profile);

  User.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _tag = json['tag'],
        profile = json['pic'];

  String get tag => _tag;

  String get username => _username;

  String get initials => username.contains(' ') ? username.split(' ').getRange(0, 1).join() : username.substring(0, 1).toUpperCase();
}
