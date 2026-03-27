import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool? isSuccess;
  final bool isInProgress;
  final EdgeInsetsGeometry padding;
  final bool expand;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isSuccess,
    this.isInProgress = false,
    this.padding = const EdgeInsets.all(20),
    this.expand = true,
  });

  static const double iconSize = 20;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          if (isSuccess != null || isInProgress) const SizedBox(width: 5),
          if (isSuccess == true) const Icon(Icons.sentiment_satisfied_alt, color: Colors.green, size: iconSize)
          else if (isSuccess == false) const Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size: iconSize)
          else if (isInProgress)
            const SizedBox(width: iconSize, height: iconSize, child: CircularProgressIndicator(color: Colors.green, strokeWidth: 2))
        ],
      ),
    );

    final content = expand ? SizedBox(width: double.infinity, child: button) : button;
    if (padding == EdgeInsets.zero) return content;

    return Padding(
      padding: padding,
      child: content,
    );
  }
}
