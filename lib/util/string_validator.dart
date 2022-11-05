extension Validation on String {
  bool isUsernameValidLength() {
    return length > 4 && length < 20 && isNotEmpty;
  }

  bool isPasswordValidLength() {
    return length > 4 && isNotEmpty;
  }

  bool isTagValidLength() {
    return length > 5 && length < 15;
  }
}
