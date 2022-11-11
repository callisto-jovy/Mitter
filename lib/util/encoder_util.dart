class PacketParser {
  static const List<String> validPackets = [
    'CRT',
    'ACC',
    'CHT',
    'USR',
  ];

  final List<String> _tokens;

  //TODO: Packet rules
  PacketParser(this._tokens);

  String get id => _tokens.first;

  String get stamp => _tokens[2];

  String nthArgument(final int n) => (n + 2) < _tokens.length ? _tokens[n + 2] : 'N/A';

  List<String> get arguments => _tokens.sublist(2); //Strip the id and the stamp

  bool isPacketValid() =>
      _tokens.isNotEmpty &&
      _tokens.length > 2 &&
      validPackets.contains(_tokens.first) &&
      _tokens[1].isNotEmpty;
}

class PacketScanner {
  static bool isValidForm(final String input) => input.isNotEmpty && input.split(' ').isNotEmpty;

  static List<String> tokenize(final String input) {
    List<String> tokens = [];
    for (int i = 0; i < input.length; i++) {
      var char = input[i];
      if (char == ' ') {
        final int nextValidSpace = _nextValidSpace(i, input);
        if (nextValidSpace != -1) tokens.add(input.substring(i, nextValidSpace));
      }
    }
    return List.empty();
  }

  static int _nextValidSpace(int start, String string) {
    for (int j = start; j < string.length; j++) {
      var charJ = string[j];
      //Next space which is not escaped
      if (charJ == ' ' && string[j - 1] != '\\') {
        return j;
      }
    }
    return -1;
  }
}
