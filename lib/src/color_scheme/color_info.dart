import 'dart:ui';

/// Information about a color in the theme
class ColorInfo {
  /// Name of the color
  final String name;

  /// The color value
  final Color color;

  /// Contrast color to display the name of the color
  final Color? textColor;

  /// Creates information about a color
  const ColorInfo({required this.name, required this.color, this.textColor});
}
