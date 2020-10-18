import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType inputType;
  final String errorText;

  const TextInput(
      {Key key,
      @required this.hint,
      @required this.controller,
      this.obscure = false,
      this.inputType = TextInputType.text,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      obscureText: obscure,
      validator: (string) {
        return string.isEmpty ? errorText : null;
      },
      style: Theme.of(context).textTheme.headline4,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.subtitle2,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
