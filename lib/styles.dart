import 'package:flutter/material.dart';
import 'constants.dart';

class CustomColor {
  static Color provider(String provider) {
    return switch (provider) {
      ProviderId.telegram => const Color(0xFF229ED9),
      ProviderId.ntfy => const Color(0xFF317F6F),
      ProviderId.smtp => const Color(0xFFEF6C00),
      ProviderId.sms => const Color(0xFF1A73E8),
      _ => Colors.blueGrey,
    };
  }

  static Color messageType(String type) {
    return switch (type) {
      'sms' => const Color(0xFF1A73E8),
      'call' => const Color(0xFF34A853),
      'sys' => const Color(0xFFFF8F00),
      _ => Colors.blueGrey,
    };
  }

  static Color rulePriority(int priority) {
    return switch (priority) {
      1 => Colors.deepOrangeAccent.withValues(alpha: 0.4),
      2 => Colors.amber.withValues(alpha: 0.4),
      4 => Colors.lightGreen.withValues(alpha: 0.4),
      5 => Colors.lightBlue.withValues(alpha: 0.4),
      _ => Colors.transparent,
    };
  }
}

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

  static const InputDecorationTheme compactDropdown = InputDecorationTheme(
    border: OutlineInputBorder(),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 13),
  );

  static final ButtonStyle compactDropdownItem = MenuItemButton.styleFrom(
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
    )
  );
}
