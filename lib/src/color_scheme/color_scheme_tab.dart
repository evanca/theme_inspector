import 'package:flutter/material.dart';
import 'package:theme_inspector/src/shared/clipboard_service.dart';
import 'package:theme_inspector/src/shared/color_chip.dart';
import 'package:theme_inspector/src/shared/section_title.dart';

import 'color_info.dart';
import 'color_section.dart';

/// A tab that displays a list of color sections from the app's color scheme
class ColorSchemeTab extends StatelessWidget {
  /// Additional color sections to display in the tab
  final List<ColorSection>? additionalColors;

  const ColorSchemeTab({super.key, this.additionalColors});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<ColorSection> colorSections = [
      if (additionalColors != null) ...additionalColors!,
      ColorSection(
        title: 'Primary',
        colors: [
          ColorInfo(
            name: 'primary',
            color: colorScheme.primary,
            textColor: colorScheme.onPrimary,
          ),
          ColorInfo(
            name: 'onPrimary',
            color: colorScheme.onPrimary,
            textColor: colorScheme.primary,
          ),
        ],
      ),
      ColorSection(
        title: 'Secondary',
        colors: [
          ColorInfo(
            name: 'secondary',
            color: colorScheme.secondary,
            textColor: colorScheme.onSecondary,
          ),
          ColorInfo(
            name: 'onSecondary',
            color: colorScheme.onSecondary,
            textColor: colorScheme.secondary,
          ),
        ],
      ),
      ColorSection(
        title: 'Surface',
        colors: [
          ColorInfo(
            name: 'surface',
            color: colorScheme.surface,
            textColor: colorScheme.onSurface,
          ),
          ColorInfo(
            name: 'onSurface',
            color: colorScheme.onSurface,
            textColor: colorScheme.surface,
          ),
        ],
      ),
      ColorSection(
        title: 'Error',
        colors: [
          ColorInfo(
            name: 'error',
            color: colorScheme.error,
            textColor: colorScheme.onError,
          ),
          ColorInfo(
            name: 'onError',
            color: colorScheme.onError,
            textColor: colorScheme.error,
          ),
        ],
      ),
      ColorSection(
        title: 'Outline',
        colors: [
          ColorInfo(name: 'outline', color: colorScheme.outline),
          ColorInfo(name: 'outlineVariant', color: colorScheme.outlineVariant),
        ],
      ),
      ColorSection(
        title: 'Surface Container Low',
        colors: [
          ColorInfo(
            name: 'surfaceContainerLow',
            color: colorScheme.surfaceContainerLow,
          ),
        ],
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        for (final section in colorSections)
          ColorSectionWidget(title: section.title, colors: section.colors),
      ],
    );
  }
}

/// A widget that displays a section of colors with a title
class ColorSectionWidget extends StatelessWidget {
  final String title;
  final List<ColorInfo> colors;

  const ColorSectionWidget({
    super.key,
    required this.title,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: title, color: colors.first.color),
        const SizedBox(height: 12),
        ...colors.map((colorInfo) => ColorCard(colorInfo: colorInfo)),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// A card that displays information about a color including its name and hex value
class ColorCard extends StatelessWidget {
  final ColorInfo colorInfo;

  const ColorCard({super.key, required this.colorInfo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hexColor = _colorToHex(colorInfo.color);

    final chipColor =
        Color.lerp(colorInfo.color, Colors.black, 0.4) ?? Colors.black54;
    final chipTextColor = _getContrastColor(chipColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: colorInfo.color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  colorInfo.name,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    color:
                        colorInfo.textColor ??
                        _getContrastColor(colorInfo.color),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Row(
                children: [
                  ColorChip(
                    text: hexColor,
                    backgroundColor: chipColor,
                    textColor: chipTextColor,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 16,
                      color: _getContrastColor(colorInfo.color),
                    ),
                    onPressed:
                        () => ClipboardService.copyToClipboard(
                          context,
                          '${colorInfo.name}: $hexColor',
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a contrasting color for the given color
  Color _getContrastColor(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  /// Converts a color to a hexadecimal string representation
  String _colorToHex(Color color) {
    final alphaPercent = (color.a * 100).round();

    final result =
        '#${(color.r * 255).round().toRadixString(16).padLeft(2, '0')}'
        '${(color.g * 255).round().toRadixString(16).padLeft(2, '0')}'
        '${(color.b * 255).round().toRadixString(16).padLeft(2, '0')}'
        ' $alphaPercent%';

    return result.toUpperCase();
  }
}
