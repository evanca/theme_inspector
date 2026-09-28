import 'dart:math' as math;
import 'dart:ui';

/// WCAG 2 conformance level a contrast ratio reaches for text.
enum ContrastGrade {
  /// 7:1 or more: enhanced contrast for body text.
  aaa('AAA'),

  /// 4.5:1 or more: minimum contrast for body text.
  aa('AA'),

  /// 3:1 or more: minimum contrast for large text (24 px, or 18.5 px bold).
  aaLarge('AA large'),

  /// Below 3:1: fails for text of any size.
  low('Low');

  const ContrastGrade(this.label);

  /// Short label shown next to the ratio.
  final String label;

  /// The best level [ratio] reaches. Compares the unrounded ratio, as WCAG
  /// does, so 4.49:1 is [aaLarge] even though it displays as 4.4.
  static ContrastGrade of(double ratio) => switch (ratio) {
    >= 7 => aaa,
    >= 4.5 => aa,
    >= 3 => aaLarge,
    _ => low,
  };
}

/// WCAG 2 contrast ratio between [foreground] and [background], 1 to 21.
///
/// Translucent colours are composited first: [background] over [backdrop],
/// then [foreground] over the result, so the ratio describes what is painted.
double contrastRatio(
  Color foreground,
  Color background, {
  Color backdrop = const Color(0xFFFFFFFF),
}) {
  final Color back = Color.alphaBlend(background, backdrop);
  final Color front = Color.alphaBlend(foreground, back);
  final double a = front.computeLuminance();
  final double b = back.computeLuminance();
  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
}

/// [ratio] truncated, not rounded, to one decimal, e.g. `4.4` for 4.49.
///
/// Rounding would print 4.5 beside an "AA large" grade and look like a bug.
String formatContrastRatio(double ratio) =>
    ((ratio * 10).floor() / 10).toStringAsFixed(1);
