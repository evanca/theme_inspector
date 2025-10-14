import 'package:flutter/material.dart';
import 'package:theme_inspector/src/shared/clipboard_service.dart';
import 'package:theme_inspector/src/text_theme/text_style_info.dart';

class TextThemeTab extends StatelessWidget {
  const TextThemeTab({super.key, this.additionalTextStyles});

  final List<TextStyleInfo>? additionalTextStyles;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final textStyles = [
      if (additionalTextStyles != null) ...additionalTextStyles!,
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  textStyleInfo.name,
                  style: style,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '${style.fontSize?.toStringAsFixed(0) ?? ""}px',
                style: style,
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.copy, size: 16),
                onPressed:
                    () => ClipboardService.copyToClipboard(
                      context,
                      '${textStyleInfo.name}: '
                      '${style.fontSize?.toStringAsFixed(0) ?? ""}px'
                      ', ${style.fontWeight != null ? style.fontWeight!.toString() : ""}'
                      ', fontFamily: ${style.fontFamily ?? "default"}',
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
