import 'package:material_ui/material_ui.dart';

import '../shared/clipboard_service.dart';
import '../shared/color_hex.dart';
import '../shared/contrast.dart';
import 'color_info.dart';

/// A colour role shown with its on-colour, their contrast ratio and, for
/// built-in roles, how many widgets in the preview read it.
///
/// Tapping the tile selects it; the copy button copies the hex value.
class ColorTile extends StatelessWidget {
  /// Creates a tile for [info].
  const ColorTile({
    super.key,
    required this.info,
    required this.selected,
    this.onTap,
    this.usageCount,
  });

  /// The colour and its on-colour.
  final ColorInfo info;

  /// Whether this tile's colour is shown in the "where used" panel.
  final bool selected;

  /// Called when the tile is tapped. When null the tile is not selectable.
  final VoidCallback? onTap;

  /// Number of preview usages, or null for colours the preview cannot map,
  /// such as the app's own custom colours.
  final int? usageCount;

  /// The colour drawn on [info]'s colour: its [ColorInfo.textColor], or black
  /// or white, whichever contrasts more.
  static Color foregroundOf(ColorInfo info) =>
      info.textColor ??
      (ThemeData.estimateBrightnessForColor(info.color) == Brightness.dark
          ? Colors.white
          : Colors.black);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final TextTheme text = theme.textTheme;
    final Color foreground = foregroundOf(info);
    final String hex = formatHex(info.color);
    final double ratio = contrastRatio(
      foreground,
      info.color,
      backdrop: colors.surface,
    );
    final String? onName = switch ((info.textColorName, info.textColor)) {
      (final String name?, final Color color?) => '$name · ${formatHex(color)}',
      (final String name?, null) => name,
      (null, final Color color?) => formatHex(color),
      (null, null) => null,
    };

    return Semantics(
      selected: selected,
      child: Material(
        color: colors.surfaceContainerLowest,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: selected
              ? BorderSide(color: colors.onSurface, width: 3)
              : BorderSide(color: colors.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ColoredBox(
                color: info.color,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info.name,
                              style: text.titleMedium?.copyWith(
                                color: foreground,
                              ),
                            ),
                            if (onName != null)
                              Text(
                                onName,
                                style: text.bodySmall?.copyWith(
                                  color: foreground,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ExcludeSemantics(
                        child: Text(
                          'Aa',
                          style: text.headlineMedium?.copyWith(
                            color: foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            hex,
                            style: text.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                          _Badge(
                            '${formatContrastRatio(ratio)} '
                            '${ContrastGrade.of(ratio).label}',
                            filled: true,
                          ),
                          if (usageCount case final int count?)
                            _Badge(count == 1 ? '1 use' : '$count uses'),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copy ${info.name}',
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () => ClipboardService.copyToClipboard(
                        context,
                        '${info.name}: $hex',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, {this.filled = false});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled ? colors.secondaryContainer : null,
        border: filled ? null : Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: filled
                ? colors.onSecondaryContainer
                : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
