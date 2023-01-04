import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/chat/chat.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/util/encoder_util.dart';
import 'package:it_class_frontend/util/packets/packets.dart';
import 'package:it_class_frontend/util/packets/user_get_packet.dart';
import 'package:it_class_frontend/util/security_util.dart';

import '../users/user.dart';

const int key_rounds = 30;
const int key_length = 256;
const int salt_length = 0;
final PBKDF2 hashing = PBKDF2(hashAlgorithm: sha512224);

void login(final String tag, final String password, Function(bool) accepted) async {
  final String generatedHash =
      hashing.generateBase64Key(tag + password, Salt.generate(salt_length), key_rounds, key_length);
  //Send off to server to validate and register callback
  Get.find<SocketInterface>().send(SignInPacket(tag, generatedHash),
      whenReceived: (PacketCapsule value) {
    if (value.operation == 'COMPLETE') {
      //Update all information
      localUser = User(value.nthArgument(0), value.nthArgument(1), value.nthArgument(2));
      final List<String> previousPartners = value.extrapolateList(3);
      accepted.call(true);

      chatHandler.addPreviousChats(previousPartners);
    } else {
      accepted.call(false);
    }
  });
}

void signUp(
    final String tag, final String password, final String username, Function(bool) signedUp) {
  final String generatedHash =
      hashing.generateBase64Key(tag + password, Salt.generate(salt_length), key_rounds, key_length);
  //Send data
  Get.find<SocketInterface>().send(SignUpPacket(username, tag, generatedHash),
      whenReceived: (PacketCapsule value) => signedUp.call(value.operation == 'CREATED'));
}
