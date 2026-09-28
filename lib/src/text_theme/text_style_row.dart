import 'package:material_ui/material_ui.dart';

import '../shared/clipboard_service.dart';
import 'text_style_info.dart';

/// Width an [IconButton] occupies at its default minimum tap target.
const double _kCopyButtonWidth = 48.0;

/// Horizontal padding inside a metric chip.
const double _kChipPadding = 8.0;

const double _kGap = 6.0;

/// Label for a style's font size, e.g. `57px`.
String fontSizeLabel(TextStyle style) =>
    '${style.fontSize?.toStringAsFixed(0) ?? ""}px';

/// Label for a style's weight, e.g. `w400`.
String fontWeightLabel(TextStyle style) =>
    'w${style.fontWeight?.value ?? FontWeight.normal.value}';

/// One text style: its name set in the style itself, its size and weight, and
/// a copy button. Tapping the row selects it.
class TextStyleRow extends StatelessWidget {
  /// Creates a row for [info], whose style must not be null.
  const TextStyleRow({
    super.key,
    required this.info,
    required this.selected,
    required this.onTap,
  });

  /// The style and its name.
  final TextStyleInfo info;

  /// Whether this style is shown in the "where used" panel.
  final bool selected;

  /// Called when the row is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = info.style!;
    final String size = fontSizeLabel(style);
    final String weight = fontWeightLabel(style);

    // The name is the specimen: it is rendered in the style being described,
    // so displayLarge really is ~57 px tall. The metrics are only labels, so
    // they stay at a fixed small size instead of consuming the specimen's
    // width.
    final TextStyle? labelStyle = Theme.of(context).textTheme.labelMedium;

    final Widget specimen = Text(
      info.name,
      style: style,
      overflow: TextOverflow.ellipsis,
    );

    final Widget meta = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MetricChip(size, style: labelStyle, filled: true),
        const SizedBox(width: _kGap),
        _MetricChip(weight, style: labelStyle),
        const SizedBox(width: _kGap),
        IconButton(
          tooltip: 'Copy ${info.name}',
          icon: const Icon(Icons.copy, size: 16),
          onPressed: () => ClipboardService.copyToClipboard(
            context,
            '${info.name}: $size'
            ', ${style.fontWeight != null ? style.fontWeight!.toString() : ""}'
            ', fontFamily: ${style.fontFamily ?? "default"}',
          ),
        ),
      ],
    );

    return Semantics(
      selected: selected,
      child: Material(
        color: selected
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Measure rather than guess a breakpoint: whether a specimen
                // fits beside its labels depends on the style's own size, so
                // the answer differs per row and with the user's text scale.
                final double specimenWidth = _measure(
                  context,
                  info.name,
                  style,
                );
                final double metaWidth =
                    _measure(context, size, labelStyle) +
                    _measure(context, weight, labelStyle) +
                    _kChipPadding * 4 +
                    _kGap * 2 +
                    _kCopyButtonWidth;

                if (specimenWidth + 8 + metaWidth <= constraints.maxWidth) {
                  return Row(
                    children: [
                      Expanded(child: specimen),
                      const SizedBox(width: 8),
                      meta,
                    ],
                  );
                }

                // Give the specimen the full width and drop the labels
                // beneath it.
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [specimen, meta],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Width [text] needs when painted in [style], at the ambient text scale.
  static double _measure(BuildContext context, String text, TextStyle? style) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final double width = painter.width;
    painter.dispose();
    return width;
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip(this.label, {required this.style, this.filled = false});

  final String label;
  final TextStyle? style;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled ? colors.secondaryContainer : null,
        border: Border.all(
          color: filled ? colors.secondaryContainer : colors.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kChipPadding - 1,
          vertical: 2,
        ),
        child: Text(
          label,
          style: style?.copyWith(
            color: filled
                ? colors.onSecondaryContainer
                : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
