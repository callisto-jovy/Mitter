import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/util/packets/packets.dart';
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
  Get.find<SocketInterface>().send(SignInPacket(tag, generatedHash)).then((value) {
    if (value.operation == 'COMPLETE') {
      localUser = User.fromJson(value.nthArgument(0));
      chatHandler.addPreviousChats(List<String>.from(value.nthArgument(1)));
    }
    accepted.call(value.operation == 'COMPLETE');
  });
}

void signUp(
    final String tag, final String password, final String username, Function(bool) signedUp) {
  final String generatedHash =
      hashing.generateBase64Key(tag + password, Salt.generate(salt_length), key_rounds, key_length);
  //Send data
  Get.find<SocketInterface>()
      .send(SignUpPacket(username, tag, generatedHash))
      .then((value) => signedUp.call(value.operation == 'CREATED'));
}
