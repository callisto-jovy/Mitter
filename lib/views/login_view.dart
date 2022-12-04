import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/util/string_validator.dart';
import 'package:it_class_frontend/views/sign_up_view.dart';
import 'package:it_class_frontend/widgets/full_width_elevated_button.dart';

import '../constants.dart';
import '../controller/simple_ui_controller.dart';
import '../util/password_util.dart';
import 'main_page_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController tagController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    tagController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final SimpleUIController simpleUIController = Get.find<SimpleUIController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController);
            } else {
              return _buildSmallScreen(size, simpleUIController);
            }
          },
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
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
            'Login',
            style: loginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Welcome Back',
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
                /// username or Gmail
                TextFormField(
                  style: textFormFieldStyle(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.tag_rounded),
                    hintText: 'Tag',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: tagController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a tag.';
                    } else if (!value.isTagValidLength()) {
                      return errorMessageInvalidLength('tag', lower: 4, upper: 20);
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: textFormFieldStyle(),
                    controller: passwordController,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password.';
                      } else if (!value.isPasswordValidLength()) {
                        return errorMessageInvalidLength('password', lower: 4, upper: 20);
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Login Button
                FullWidthElevatedButton(
                    onPressed: () {
                      if (!Get.find<SocketInterface>().isConnected) {
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        validateLogin(tagController.text, passwordController.text,
                            (accepted, user) {
                          if (accepted) {
                            //Set local user
                            localUser = user;
                            Navigator.pushReplacement(
                                context, CupertinoPageRoute(builder: (ctx) => const MainView()));
                          } else {
                            simpleUIController.isPasswordInvalid.toggle();
                          }
                        });
                      }
                    },
                    buttonText: 'Login',
                    height: 55),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (ctx) => const SignUpView()));
                    tagController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();
                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: loginFinePrintStyle(size),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: loginFinePrintStyle(size,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
                simpleUIController.isPasswordInvalid.value
                    ? const Text(
                        'Password or username is invalid.',
                        style: TextStyle(color: Colors.redAccent),
                      )
                    : const SizedBox(),
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
