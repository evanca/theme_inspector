import 'package:flutter/material.dart';

/// Information about a text style in the theme
class TextStyleInfo {
  /// Name of the text style
  final String name;

  /// The text style
  final TextStyle? style;

  /// Creates information about a text style
  const TextStyleInfo(this.name, this.style);
}