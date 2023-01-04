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

  String nthArgument(final int n) => (n + 3) < _tokens.length ? _tokens[n + 3] : '';

  List<String> get arguments => _tokens.sublist(3); //Strip the id, operation and the stamp

  List<String> extrapolateList(final int n) {
    final String input = nthArgument(n);
    if (!(input.startsWith('[') && input.endsWith(']'))) {
      return List.empty();
    }

    List<String> items = [];

    int lastColon = 1;
    for (int i = 1; i < input.length - 2; i++) {
      var char = input[i];

      if (char == '\\') {
        //Move to next, continue, the next entry then is skipped.
        i++;
        continue;
      }
      if (char == ',') {
        final String item = input.substring(lastColon, i);
        items.add(item);
        lastColon = i + 1;
      } else if (i + 1 == input.length - 2) {
        items.add(input.substring(lastColon, input.length - 1));
      }
    }
    return items;
  }

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
  This means: The packet's general id, the packet's "arg"; the operation to perform,
  the response code - which may be listened to and always has to be returned! - followed by a list of arguments.
  An argument may be a list, which is denoted by a opening bracket: '[' and a closing bracket: ']'.
  It may look as follows: A0;[X0, X1, X2, X3, Xn];A2;A3;An. The whole packet would look like this:
          XXX;XXX;0-9+;A0;[X0, X1, X2, X3, Xn];A2;A3;An
  This functionality - however - is yet to be implemented, as it's not used by the client for now (as of 02.01.2023).
   */

  static List<String> format(final Map<String, dynamic> map) {
    final String arguments =
        map['arguments'].map((String s) => s.replaceAll(r";", "\\;")).join(";");

    final String stamp = newStamp;
    return ['${map['id']};${map['arg']};$stamp;$arguments', stamp];
  }
}
