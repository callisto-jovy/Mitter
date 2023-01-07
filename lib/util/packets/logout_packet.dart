import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packet.dart';

class LogoutPacket extends Packet {
  LogoutPacket();

  @override
  Future<Map<String, dynamic>> send() async => {
        keyId: "ACC",
        keyOperation: "LOT",
        keyArguments: [
          localUser.tag,
        ]
      };

  @override
  bool isResponseValid(final PacketCapsule packetCapsule) => packetCapsule.operation == 'LOGGED OUT"';
}
