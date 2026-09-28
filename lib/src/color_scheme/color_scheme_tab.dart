import 'package:material_ui/material_ui.dart';

import '../shared/where_used.dart';
import 'color_info.dart';
import 'color_preview.dart';
import 'color_section.dart';
import 'color_tile.dart';
import 'color_usages.dart';

/// Narrowest a colour tile gets before the grid drops a column.
const double _kTileMinWidth = 280.0;

/// Most columns the grid uses, however wide the screen.
const int _kMaxColumns = 3;

const double _kGap = 12.0;

/// A colour tile's data: the colour, and the preview widgets that read it.
///
/// [usages] is null for the app's own colours, which no built-in widget reads.
typedef _ColorEntry = ({ColorInfo info, List<WidgetUsage>? usages});

/// A tab that shows the app's colour roles as tiles, each paired with its
/// on-colour, and which built-in widgets paint with the selected one.
class ColorSchemeTab extends StatefulWidget {
  /// Additional color sections to display in the tab
  final List<ColorSection>? additionalColors;

  const ColorSchemeTab({super.key, this.additionalColors});

  @override
  State<ColorSchemeTab> createState() => _ColorSchemeTabState();
}

class _ColorSchemeTabState extends State<ColorSchemeTab> {
  /// Section title and colour name of the selected tile.
  (String, String)? _selected;

  @override
  Widget build(BuildContext context) {
    final List<(String, List<_ColorEntry>)> sections = [
      for (final ColorSection section in widget.additionalColors ?? const [])
        (
          section.title,
          [
            for (final ColorInfo info in section.colors)
              (info: info, usages: null),
          ],
        ),
      ..._builtInSections(Theme.of(context).colorScheme),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= kWhereUsedPanelMinWidth;
        final (String, String)? selected =
            _selected ?? (wide ? _firstBuiltIn(sections) : null);

        final Widget grid = _ColorGrid(
          sections: sections,
          selected: selected,
          onSelect: (key, entry) => _select(key, entry, wide: wide),
        );
        if (!wide) return grid;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: grid),
            WhereUsedSidePanel(
              child: _ColorWhereUsed(entry: _entryFor(sections, selected)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _select(
    (String, String) key,
    _ColorEntry entry, {
    required bool wide,
  }) async {
    setState(() => _selected = key);
    if (wide) return;

    await showWhereUsedSheet(
      context,
      (controller) => _ColorWhereUsed(entry: entry, controller: controller),
    );
    if (mounted) setState(() => _selected = null);
  }

  static (String, String)? _firstBuiltIn(
    List<(String, List<_ColorEntry>)> sections,
  ) {
    for (final (String title, List<_ColorEntry> entries) in sections) {
      for (final _ColorEntry entry in entries) {
        if (entry.usages != null) return (title, entry.info.name);
      }
    }
    return null;
  }

  static _ColorEntry? _entryFor(
    List<(String, List<_ColorEntry>)> sections,
    (String, String)? key,
  ) {
    for (final (String title, List<_ColorEntry> entries) in sections) {
      for (final _ColorEntry entry in entries) {
        if ((title, entry.info.name) == key) return entry;
      }
    }
    return null;
  }
}

/// The built-in roles, each paired with the on-colour drawn on it.
List<(String, List<_ColorEntry>)> _builtInSections(ColorScheme s) {
  // A role tile. It lists the on-colour's usages too, unless the text colour
  // is not really the role's on-colour: `outline` is drawn with `surface`
  // only to show their contrast, and `onSurface` belongs to the surface tile.
  _ColorEntry role(
    String name,
    Color color,
    String onName,
    Color onColor, {
    bool includeOnUsages = true,
  }) => (
    info: ColorInfo(
      name: name,
      color: color,
      textColor: onColor,
      textColorName: onName,
    ),
    usages: colorUsagesFor(name, includeOnUsages ? onName : null),
  );

  return [
    (
      'Primary',
      [
        role('primary', s.primary, 'onPrimary', s.onPrimary),
        role(
          'primaryContainer',
          s.primaryContainer,
          'onPrimaryContainer',
          s.onPrimaryContainer,
        ),
      ],
    ),
    (
      'Secondary',
      [
        role('secondary', s.secondary, 'onSecondary', s.onSecondary),
        role(
          'secondaryContainer',
          s.secondaryContainer,
          'onSecondaryContainer',
          s.onSecondaryContainer,
        ),
      ],
    ),
    (
      'Tertiary',
      [
        role('tertiary', s.tertiary, 'onTertiary', s.onTertiary),
        role(
          'tertiaryContainer',
          s.tertiaryContainer,
          'onTertiaryContainer',
          s.onTertiaryContainer,
        ),
      ],
    ),
    (
      'Error',
      [
        role('error', s.error, 'onError', s.onError),
        role(
          'errorContainer',
          s.errorContainer,
          'onErrorContainer',
          s.onErrorContainer,
        ),
      ],
    ),
    (
      'Surface',
      [
        role('surface', s.surface, 'onSurface', s.onSurface),
        role(
          'surfaceContainerLow',
          s.surfaceContainerLow,
          'onSurface',
          s.onSurface,
          includeOnUsages: false,
        ),
      ],
    ),
    (
      'Outline',
      [
        role(
          'outline',
          s.outline,
          'surface',
          s.surface,
          includeOnUsages: false,
        ),
        role(
          'outlineVariant',
          s.outlineVariant,
          'onSurface',
          s.onSurface,
          includeOnUsages: false,
        ),
      ],
    ),
  ];
}

class _ColorGrid extends StatelessWidget {
  const _ColorGrid({
    required this.sections,
    required this.selected,
    required this.onSelect,
  });

  final List<(String, List<_ColorEntry>)> sections;
  final (String, String)? selected;
  final void Function((String, String) key, _ColorEntry entry) onSelect;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        const double padding = 16.0;
        final double width = constraints.maxWidth - padding * 2;
        // No more columns than the largest section fills: the built-in
        // sections hold two roles each, and a third column would stay empty.
        final int longest = sections.fold(
          1,
          (most, section) =>
              section.$2.length > most ? section.$2.length : most,
        );
        final int columns = ((width + _kGap) ~/ (_kTileMinWidth + _kGap)).clamp(
          1,
          longest < _kMaxColumns ? longest : _kMaxColumns,
        );
        final double tileWidth = (width - _kGap * (columns - 1)) / columns;

        return ListView(
          padding: const EdgeInsets.all(padding),
          children: [
            for (final (String title, List<_ColorEntry> entries) in sections)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: _kGap,
                      runSpacing: _kGap,
                      children: [
                        for (final _ColorEntry entry in entries)
                          SizedBox(
                            width: tileWidth,
                            child: ColorTile(
                              info: entry.info,
                              usageCount: entry.usages?.length,
                              selected: selected == (title, entry.info.name),
                              onTap: () =>
                                  onSelect((title, entry.info.name), entry),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ColorWhereUsed extends StatelessWidget {
  const _ColorWhereUsed({required this.entry, this.controller});

  final _ColorEntry? entry;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final _ColorEntry? entry = this.entry;
    if (entry == null) return const SizedBox.shrink();

    final List<WidgetUsage> usages = entry.usages ?? const [];
    return WhereUsedPanel(
      controller: controller,
      title: entry.info.name,
      leading: SizedBox.square(
        dimension: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: entry.info.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
      ),
      preview: const ColorPreview(),
      usages: usages,
      emptyMessage: entry.usages == null
          ? 'This is your own colour, so no built-in widget reads it. It '
                'appears only where your code uses it.'
          : 'None of the widgets in this preview read this role by default.',
    );
  }
}
