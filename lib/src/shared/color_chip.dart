import 'package:flutter/material.dart';

/// A customizable chip that displays text with configurable background and text colors
class ColorChip extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const ColorChip({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(
          color: textColor,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
