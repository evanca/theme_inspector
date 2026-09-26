import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/shared/clipboard_service.dart';
import 'package:theme_inspector/src/text_theme/text_style_info.dart';

/// Width an [IconButton] occupies at its default minimum tap target.
const double _kCopyButtonWidth = 48.0;

class TextThemeTab extends StatelessWidget {
  const TextThemeTab({super.key, this.additionalTextStyles});

  final List<TextStyleInfo>? additionalTextStyles;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final textStyles = [
      ...?additionalTextStyles,
      TextStyleInfo('displayLarge', textTheme.displayLarge),
      TextStyleInfo('displayMedium', textTheme.displayMedium),
      TextStyleInfo('displaySmall', textTheme.displaySmall),
      TextStyleInfo('headlineLarge', textTheme.headlineLarge),
      TextStyleInfo('headlineMedium', textTheme.headlineMedium),
      TextStyleInfo('headlineSmall', textTheme.headlineSmall),
      TextStyleInfo('titleLarge', textTheme.titleLarge),
      TextStyleInfo('titleMedium', textTheme.titleMedium),
      TextStyleInfo('titleSmall', textTheme.titleSmall),
      TextStyleInfo('bodyLarge', textTheme.bodyLarge),
      TextStyleInfo('bodyMedium', textTheme.bodyMedium),
      TextStyleInfo('bodySmall', textTheme.bodySmall),
      TextStyleInfo('labelLarge', textTheme.labelLarge),
      TextStyleInfo('labelMedium', textTheme.labelMedium),
      TextStyleInfo('labelSmall', textTheme.labelSmall),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: textStyles.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final textStyleInfo = textStyles[index];
        return _TextStyleCard(textStyleInfo: textStyleInfo);
      },
    );
  }
}

class _TextStyleCard extends StatelessWidget {
  final TextStyleInfo textStyleInfo;

  const _TextStyleCard({required this.textStyleInfo});

  @override
  Widget build(BuildContext context) {
    final style = textStyleInfo.style;

    if (style == null) {
      return const SizedBox.shrink();
    }

    final String sizeLabel = '${style.fontSize?.toStringAsFixed(0) ?? ""}px';

    // The name is the specimen: it is rendered in the style being described, so
    // displayLarge really is ~57 px tall. The size is only a label, so it stays
    // at a fixed small size instead of consuming the width of the specimen.
    final TextStyle? labelStyle = Theme.of(context).textTheme.bodySmall;

    final Widget specimen = Text(
      textStyleInfo.name,
      style: style,
      overflow: TextOverflow.ellipsis,
    );

    final Widget meta = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(sizeLabel, style: labelStyle),
        const SizedBox(width: 4),
        IconButton(
          icon: Icon(Icons.copy, size: 16),
          onPressed: () => ClipboardService.copyToClipboard(
            context,
            '${textStyleInfo.name}: $sizeLabel'
            ', ${style.fontWeight != null ? style.fontWeight!.toString() : ""}'
            ', fontFamily: ${style.fontFamily ?? "default"}',
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Measure rather than guess a breakpoint: whether a specimen fits
          // beside its label depends on the style's own size, so the answer
          // differs per row and with the user's text scale.
          final double specimenWidth = _measure(
            context,
            textStyleInfo.name,
            style,
          );
          final double labelWidth = _measure(context, sizeLabel, labelStyle);
          final double metaWidth = labelWidth + 4 + _kCopyButtonWidth;

          if (specimenWidth + 8 + metaWidth <= constraints.maxWidth) {
            return Row(
              children: [
                Expanded(child: specimen),
                const SizedBox(width: 8),
                meta,
              ],
            );
          }

          // Give the specimen the full width and drop the label beneath it.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [specimen, meta],
          );
        },
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
