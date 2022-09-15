import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController txtController;
  final IconData iconValue;
  final TextInputType type;
  final bool visible;
  const CustomInputField({
    Key? key,
    required this.labelText,
    required this.txtController,
    required this.iconValue,
    required this.type,
    required this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: TextFormField(
        controller: txtController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          label: Text(labelText),
          prefixIcon: Icon(iconValue),
        ),
        validator: (val) => (val!.isEmpty) ? 'Enter the $labelText' : null,
        keyboardType: type,
        obscureText: visible,
      ),
    );
  }
}
