import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  void showErrorSnack(String message) {
    if (message.isEmpty) return;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
