import 'package:flutter/material.dart';

class CustomStyle {
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
  );

  static InputDecoration compactInput({
    required String labelText,
    String? helperText,
    FloatingLabelBehavior? floatingLabelBehavior,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: labelText,
      helperText: helperText,
      helperMaxLines: 2,
      floatingLabelBehavior: floatingLabelBehavior,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      prefixIcon: prefixIcon == null
          ? null
          : Padding(
              padding: const EdgeInsetsDirectional.only(start: 13, end: 6),
              child: prefixIcon,
            ),
      suffixIcon: suffixIcon,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
    );
  }
}
