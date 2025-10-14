import 'color_info.dart';

/// A section of related colors
class ColorSection {
  /// Title of the color section
  final String title;

  /// List of colors in this section
  final List<ColorInfo> colors;

  /// Creates a section of related colors
  const ColorSection({required this.title, required this.colors});
}