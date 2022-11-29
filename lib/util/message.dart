import '../users/user.dart';

class Message {
  final String content;
  final User sender;

  Message(this.sender, this.content);
}
