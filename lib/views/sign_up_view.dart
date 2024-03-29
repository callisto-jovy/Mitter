import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/util/password_util.dart';
import 'package:it_class_frontend/util/string_validator.dart';
import 'package:it_class_frontend/widgets/full_width_elevated_button.dart';

import '../constants.dart';
import '../controller/simple_ui_controller.dart';
import '../util/connection_util.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _tagController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    final SimpleUIController simpleUIController = Get.find<SimpleUIController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildLargeScreen(size, simpleUIController, theme);
              } else {
                return _buildSmallScreen(size, simpleUIController, theme);
              }
            },
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Sign Up',
            style: loginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Create Account',
            style: loginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// username
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: _usernameController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username.';
                    } else if (!value.isUsernameValidLength) {
                      return errorMessageInvalidLength('username', lower: 4, upper: 20);
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                // Tag
                TextFormField(
                  controller: _tagController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.tag_rounded),
                    hintText: 'Tag',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter a tag.';
                    } else if (!input.isTagValidLength) {
                      return errorMessageInvalidLength('tag', lower: 4, upper: 20);
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                // password
                Obx(
                  () => TextFormField(
                    //style: textFormFieldStyle(),
                    controller: _passwordController,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      errorStyle: textFormErrorStyle(),
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password.';
                      } else if (!value.isPasswordValidLength) {
                        return errorMessageInvalidLength('password', lower: 5);
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'By creating an account you agree to our ToS',
                  style: loginFinePrintStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// SignUp Button
                FullWidthElevatedButton(
                    onPressed: () {
                      if (!Get.find<SocketInterface>().isConnected) {
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        signUp(_tagController.text, _passwordController.text, _usernameController.text,
                            (value) {
                          if (value) {
                            //navigate to login
                            Navigator.pop(context);

                            _usernameController.clear();
                            _tagController.clear();
                            _passwordController.clear();
                            _formKey.currentState?.reset();

                            simpleUIController.isObscure.value = true;
                          } else {
                            //TODO: Tag already taken
                          }
                        });
                      }
                    },
                    buttonText: 'Sign Up',
                    height: 55),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    _usernameController.clear();
                    _tagController.clear();
                    _passwordController.clear();
                    _formKey.currentState?.reset();

                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: loginFinePrintStyle(size),
                      children: [
                        TextSpan(
                            text: 'Login',
                            style: loginFinePrintStyle(size,
                                color: Theme.of(context).colorScheme.secondary)),
                      ],
                    ),
                  ),
                ),
                Get.find<SocketInterface>().isConnected
                    ? const SizedBox()
                    : const Text(
                        'You are not connected to the server.',
                        style: TextStyle(color: Colors.redAccent),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
