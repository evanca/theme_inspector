import '../shared/where_used.dart';

/// Text styles read by the Material 3 defaults of the widgets in the preview,
/// keyed by `TextTheme` style name.
///
/// Taken from the `_…DefaultsM3` classes in `package:material_ui` 1.2.0.
/// Re-check this table when raising the `material_ui` constraint.
const Map<String, List<WidgetUsage>> kTextStyleUsages = {
  'headlineSmall': [WidgetUsage('AlertDialog', 'titleTextStyle')],
  'titleLarge': [WidgetUsage('AppBar', 'titleTextStyle')],
  'titleSmall': [WidgetUsage('TabBar', 'labelStyle')],
  'bodyLarge': [
    WidgetUsage('TextField', 'style'),
    WidgetUsage('ListTile', 'titleTextStyle'),
  ],
  'bodyMedium': [
    WidgetUsage('Material', 'default text style'),
    WidgetUsage('ListTile', 'subtitleTextStyle'),
    WidgetUsage('AlertDialog', 'contentTextStyle'),
  ],
  'bodySmall': [WidgetUsage('InputDecoration', 'helperStyle')],
  'labelLarge': [
    WidgetUsage('FilledButton', 'textStyle'),
    WidgetUsage('FilterChip', 'labelStyle'),
  ],
  'labelSmall': [WidgetUsage('ListTile', 'leadingAndTrailingTextStyle')],
};
