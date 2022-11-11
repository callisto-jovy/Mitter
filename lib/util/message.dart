import '../users/user.dart';

class Message {
  //TODO: Sender (User class)

  final String content;
  final User sender;

  Message(this.sender, this.content);
}
