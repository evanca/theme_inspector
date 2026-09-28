import '../shared/where_used.dart';

/// Colour roles read by the Material 3 defaults of the widgets in the
/// preview, keyed by `ColorScheme` role name.
///
/// Taken from the `_…DefaultsM3` classes in `package:material_ui` 1.2.0. Only
/// enabled, resting states are listed; hover, press and disabled overlays are
/// left out because the preview does not show them. Re-check this table when
/// raising the `material_ui` constraint.
const Map<String, List<WidgetUsage>> kColorUsages = {
  'primary': [
    WidgetUsage('FilledButton', 'backgroundColor'),
    WidgetUsage('OutlinedButton', 'foregroundColor'),
    WidgetUsage('Switch', 'trackColor (selected)'),
    WidgetUsage('TextField', 'focusedBorder'),
  ],
  'onPrimary': [
    WidgetUsage('FilledButton', 'foregroundColor'),
    WidgetUsage('Switch', 'thumbColor (selected)'),
  ],
  'primaryContainer': [WidgetUsage('FloatingActionButton', 'backgroundColor')],
  'onPrimaryContainer': [
    WidgetUsage('FloatingActionButton', 'foregroundColor'),
  ],
  'secondaryContainer': [
    WidgetUsage('FilledButton.tonal', 'backgroundColor'),
    WidgetUsage('FilterChip', 'selectedColor'),
  ],
  'onSecondaryContainer': [
    WidgetUsage('FilledButton.tonal', 'foregroundColor'),
    WidgetUsage('FilterChip', 'labelStyle (selected)'),
  ],
  'error': [
    WidgetUsage('TextField', 'errorBorder'),
    WidgetUsage('TextField', 'errorStyle'),
  ],
  'surface': [WidgetUsage('AppBar', 'backgroundColor')],
  'onSurface': [WidgetUsage('AppBar', 'foregroundColor')],
  'surfaceContainerLow': [WidgetUsage('Card', 'color')],
  'outline': [WidgetUsage('OutlinedButton', 'side')],
};

/// Usages of a role and its on-colour together, each tagged with its role.
List<WidgetUsage> colorUsagesFor(String role, String? onRole) => [
  for (final String name in [role, ?onRole])
    for (final WidgetUsage u in kColorUsages[name] ?? const [])
      WidgetUsage(u.widget, u.property, role: name),
];
