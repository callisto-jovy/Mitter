enum ErrorType {
  ACCOUNT_LOGIN_FAILED(122),
  ACCOUNT_DOES_NOT_EXIST(120),
  ACCOUNT_TAG_ALREADY_TAKEN(110),
  ACCOUNT_NOT_LOGGED_IN(112),
  ACCOUNT_NOT_LOGGED_OUT(113),
  RECEIVER_NOT_ONLINE(151),
  CHAT_DOES_NOT_EXIST(200);

  const ErrorType(this.code);

  final int code;
}

extension ErrorTypeExtension on ErrorType {
  String get description {
    switch (this) {
      case ErrorType.ACCOUNT_LOGIN_FAILED:
        return 'The account could not be logged in.';
      case ErrorType.ACCOUNT_DOES_NOT_EXIST:
        return 'The requested account does not exist.';
      case ErrorType.ACCOUNT_NOT_LOGGED_IN:
        return 'Your account is currently not logged in. Please restart the application and try again.';
      case ErrorType.ACCOUNT_TAG_ALREADY_TAKEN:
        return 'The tag you requested is already taken.';
      case ErrorType.RECEIVER_NOT_ONLINE:
        return 'This receiver does not exist';
      case ErrorType.CHAT_DOES_NOT_EXIST:
        return 'The chat you tried to access does not exist.';
      default:
        return 'Unknown Error';
    }
  }
}
