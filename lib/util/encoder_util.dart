import 'id_util.dart';

const List<String> validPackets = [
  'CRT',
  'ACC',
  'CHT',
  'USR',
  'ERR',
];

class PacketCapsule {
  final List<String> _tokens;

  PacketCapsule(this._tokens);

  String get id => _tokens.first;

  String get operation => _tokens[1];

  String get stamp => _tokens[2];

  String nthArgument(final int n) => (n + 3) < _tokens.length ? _tokens[n + 3] : 'N/A';

  List<String> get arguments => _tokens.sublist(3); //Strip the id, operation and the stamp

  bool isPacketValid() =>
      _tokens.isNotEmpty &&
      _tokens.length >= 3 &&
      validPackets.contains(_tokens.first) &&
      _tokens[1].isNotEmpty;
}

class PacketScanner {
  static bool isValidForm(final String input) => input.isNotEmpty && input.split(';').isNotEmpty;

  static List<String> tokenize(final String input) {
    List<String> tokens = [];

    int lastSemicolon = 0;
    for (int i = 0; i < input.length; i++) {
      var char = input[i];

      if (char == '\\') {
        //Move to next, continue, the next entry then is skipped.
        i++;
        continue;
      }
      if (char == ';') {
        final String token = input.substring(lastSemicolon, i);
        tokens.add(token);
        lastSemicolon = i + 1;
      } else if (i + 1 == input.length) {
        tokens.add(input.substring(lastSemicolon));
      }
    }
    return tokens;
  }
}

class PacketFormatter {
  /*
  A packet is formatted the following way: XXX;XXX;0-9+;X0;X1;Xn
  This beging: The packet's general id, the packet's "arg" the operation to perform,
  the response code, which may be listened to and always has to be returned! followed by a list of arguments
   */

  static List<String> format(final Map<String, dynamic> map) {
    final String arguments =
        map['arguments'].map((String s) => s.replaceAll(r";", "\\;")).join(";");
    final String stamp = newStamp;
    return ['${map['id']};${map['arg']};$stamp;$arguments', stamp];
  }
}
