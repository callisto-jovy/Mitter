extension Validation on String {
  bool get isUsernameValidLength {
    return length > 4 && length < 20 && isNotEmpty;
  }

  bool get isPasswordValidLength {
    return length > 4 && isNotEmpty;
  }

  bool get isTagValidLength {
    return length > 5 && length < 15;
  }

  bool get isValidUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }
}
