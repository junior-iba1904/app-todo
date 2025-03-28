import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? validatorMessage;
  final TextInputType? inputType;
  final TextAlign aling;

  const CustomInputField({
    required this.controller,
    this.labelText,
    this.hintText,
    this.validatorMessage,
    this.inputType,
    this.aling = TextAlign.start,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      textAlign: aling,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        if (value.length < 10) {
      return 'debe tener al menos 10 caracteres.';
    }
        return null;
      },
    );
  }
}
