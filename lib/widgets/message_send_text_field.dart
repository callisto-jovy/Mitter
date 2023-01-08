import 'package:flutter/material.dart';

class MessageSendField extends StatefulWidget {
  final Function(String) _onPressed;

  MessageSendField(this._onPressed, {Key? key}) : super(key: key);

  @override
  State<MessageSendField> createState() => _MessageSendFieldState();
}

class _MessageSendFieldState extends State<MessageSendField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 1.2,
      height: 50,
      child: TextFormField(
        controller: _textEditingController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (_textEditingController.text.isNotEmpty) {
                  widget._onPressed.call(_textEditingController.text);
                  _textEditingController.clear();
                }
              }),
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Your message may not be empty';
          }
          return null;
        },
        onFieldSubmitted: (value) {
          if (_textEditingController.text.isNotEmpty) {
            widget._onPressed.call(_textEditingController.text);
            _textEditingController.clear();
          }
        },
      ),
    );
  }
}
