import 'package:it_class_frontend/users/user.dart';

class UserHandler {
  List<User> users = [];

  void addUser(final User user) => containsTag(user.tag) ? null : users.add(user);

  bool containsTag(String tag) => users.any((element) => element.tag == tag);

  User getUser(String tag) => users.firstWhere((element) => element.tag == tag);
}
