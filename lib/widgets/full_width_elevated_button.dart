import 'package:flutter/material.dart';

class FullWidthElevatedButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  final double height;

  const FullWidthElevatedButton(
      {Key? key, required this.onPressed, required this.buttonText, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        autofocus: true,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () => onPressed.call(),
        child: Text(buttonText),
      ),
    );
  }
}
