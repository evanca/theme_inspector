import 'dart:ui';

/// Formats [color] as `#RRGGBB` followed by its opacity, e.g. `#6750A4 100%`.
String formatHex(Color color) {
  String channel(double value) =>
      (value * 255).round().toRadixString(16).padLeft(2, '0');
  final int alphaPercent = (color.a * 100).round();
  return '#${channel(color.r)}${channel(color.g)}${channel(color.b)}'
          ' $alphaPercent%'
      .toUpperCase();
}
