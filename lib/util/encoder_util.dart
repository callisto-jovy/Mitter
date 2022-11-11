class PacketParser {}

class PacketScanner {
  static List<String> tokenize(final String input) {
    for (int i = 0; i < input.length; i++) {
      final var char = input[i];

      if (char == ' ') {
        final int nextSpace = input.indexOf(' ', i);
      }
    }
    return List.empty();
  }
}
