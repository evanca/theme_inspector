import 'package:material_ui/material_ui.dart';

import '../shared/where_used.dart';
import 'text_style_info.dart';
import 'text_style_preview.dart';
import 'text_style_row.dart';
import 'text_style_usages.dart';

/// Style selected on wide screens before the user picks one: the default
/// text of most widgets, so its panel is rarely empty.
const String _kDefaultSelection = 'bodyLarge';

/// A text style row's data, with the preview widgets that read the style.
///
/// [usages] is null for the app's own styles, which no built-in widget reads.
typedef _StyleEntry = ({TextStyleInfo info, List<WidgetUsage>? usages});

/// A tab that lists the app's text styles, grouped by role, and shows which
/// built-in widgets use the selected one.
class TextThemeTab extends StatefulWidget {
  const TextThemeTab({super.key, this.additionalTextStyles});

  final List<TextStyleInfo>? additionalTextStyles;

  @override
  State<TextThemeTab> createState() => _TextThemeTabState();
}

class _TextThemeTabState extends State<TextThemeTab> {
  /// Group and name of the selected style.
  (String, String)? _selected;

  @override
  Widget build(BuildContext context) {
    final List<(String, List<_StyleEntry>)> groups =
        [
              if (widget.additionalTextStyles case final custom?
                  when custom.isNotEmpty)
                (
                  'Custom',
                  [for (final info in custom) (info: info, usages: null)],
                ),
              ..._builtInGroups(Theme.of(context).textTheme),
            ]
            .map(
              (group) => (
                group.$1,
                [
                  for (final entry in group.$2)
                    if (entry.info.style != null) entry,
                ],
              ),
            )
            .where((group) => group.$2.isNotEmpty)
            .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= kWhereUsedPanelMinWidth;
        final (String, String)? selected =
            _selected ?? (wide ? _defaultSelection(groups) : null);

        final Widget list = ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final (String group, List<_StyleEntry> entries) in groups) ...[
              _GroupHeader(group),
              for (final _StyleEntry entry in entries)
                TextStyleRow(
                  info: entry.info,
                  selected: selected == (group, entry.info.name),
                  onTap: () =>
                      _select((group, entry.info.name), entry, wide: wide),
                ),
            ],
          ],
        );
        if (!wide) return list;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: list),
            WhereUsedSidePanel(
              child: _StyleWhereUsed(entry: _entryFor(groups, selected)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _select(
    (String, String) key,
    _StyleEntry entry, {
    required bool wide,
  }) async {
    setState(() => _selected = key);
    if (wide) return;

    await showWhereUsedSheet(
      context,
      (controller) => _StyleWhereUsed(entry: entry, controller: controller),
    );
    if (mounted) setState(() => _selected = null);
  }

  static (String, String)? _defaultSelection(
    List<(String, List<_StyleEntry>)> groups,
  ) {
    (String, String)? first;
    for (final (String group, List<_StyleEntry> entries) in groups) {
      for (final _StyleEntry entry in entries) {
        if (entry.usages == null) continue;
        if (entry.info.name == _kDefaultSelection) {
          return (group, entry.info.name);
        }
        first ??= (group, entry.info.name);
      }
    }
    return first;
  }

  static _StyleEntry? _entryFor(
    List<(String, List<_StyleEntry>)> groups,
    (String, String)? key,
  ) {
    for (final (String group, List<_StyleEntry> entries) in groups) {
      for (final _StyleEntry entry in entries) {
        if ((group, entry.info.name) == key) return entry;
      }
    }
    return null;
  }
}

List<(String, List<_StyleEntry>)> _builtInGroups(TextTheme t) {
  _StyleEntry style(String name, TextStyle? style) => (
    info: TextStyleInfo(name, style),
    usages: kTextStyleUsages[name] ?? const [],
  );

  return [
    (
      'Display',
      [
        style('displayLarge', t.displayLarge),
        style('displayMedium', t.displayMedium),
        style('displaySmall', t.displaySmall),
      ],
    ),
    (
      'Headline',
      [
        style('headlineLarge', t.headlineLarge),
        style('headlineMedium', t.headlineMedium),
        style('headlineSmall', t.headlineSmall),
      ],
    ),
    (
      'Title',
      [
        style('titleLarge', t.titleLarge),
        style('titleMedium', t.titleMedium),
        style('titleSmall', t.titleSmall),
      ],
    ),
    (
      'Body',
      [
        style('bodyLarge', t.bodyLarge),
        style('bodyMedium', t.bodyMedium),
        style('bodySmall', t.bodySmall),
      ],
    ),
    (
      'Label',
      [
        style('labelLarge', t.labelLarge),
        style('labelMedium', t.labelMedium),
        style('labelSmall', t.labelSmall),
      ],
    ),
  ];
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _StyleWhereUsed extends StatelessWidget {
  const _StyleWhereUsed({required this.entry, this.controller});

  final _StyleEntry? entry;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final _StyleEntry? entry = this.entry;
    if (entry == null) return const SizedBox.shrink();

    final TextStyle style = entry.info.style!;
    final double? fontSize = style.fontSize;
    final String lineHeight = switch ((fontSize, style.height)) {
      (final double size?, final double height?) =>
        (size * height).round().toString(),
      _ => 'auto',
    };
    final List<WidgetUsage> usages = entry.usages ?? const [];

    return WhereUsedPanel(
      controller: controller,
      title: entry.info.name,
      subtitle:
          '${fontSize?.toStringAsFixed(0) ?? '?'} / $lineHeight'
          ' · ${fontWeightLabel(style)}'
          ' · ls ${style.letterSpacing ?? 0}'
          ' · ${style.fontFamily ?? 'default'}',
      preview: const TextStylePreview(),
      usages: usages,
      emptyMessage: entry.usages == null
          ? 'This is your own style, so no built-in widget uses it. It '
                'appears only where your code sets it.'
          : 'None of the widgets in this preview use this style by default.',
    );
  }
}
