import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/color_scheme/color_preview.dart';
import 'package:theme_inspector/src/color_scheme/color_usages.dart';
import 'package:theme_inspector/src/shared/where_used.dart';
import 'package:theme_inspector/src/text_theme/text_style_preview.dart';
import 'package:theme_inspector/src/text_theme/text_style_usages.dart';

// The "where used" tables are written by hand from material_ui's Material 3
// defaults. These tests render the real previews and check each entry against
// what the widget actually paints, so a material_ui upgrade that changes a
// default fails here instead of silently showing wrong information.

/// A colour no other role shares, so finding it in a widget's pixels proves
/// the widget reads that role. Index [i] must be below 50.
Color unique(int i) => Color.fromARGB(255, 5 * i, 250 - 5 * i, (37 * i) % 256);

/// Every role a distinct colour.
final ColorScheme scheme = ColorScheme(
  brightness: Brightness.light,
  primary: unique(1),
  onPrimary: unique(2),
  primaryContainer: unique(3),
  onPrimaryContainer: unique(4),
  secondary: unique(5),
  onSecondary: unique(6),
  secondaryContainer: unique(7),
  onSecondaryContainer: unique(8),
  tertiary: unique(9),
  onTertiary: unique(10),
  tertiaryContainer: unique(11),
  onTertiaryContainer: unique(12),
  error: unique(13),
  onError: unique(14),
  errorContainer: unique(15),
  onErrorContainer: unique(16),
  surface: unique(17),
  onSurface: unique(18),
  onSurfaceVariant: unique(19),
  surfaceDim: unique(20),
  surfaceBright: unique(21),
  surfaceContainerLowest: unique(22),
  surfaceContainerLow: unique(23),
  surfaceContainer: unique(24),
  surfaceContainerHigh: unique(25),
  surfaceContainerHighest: unique(26),
  outline: unique(27),
  outlineVariant: unique(28),
  inverseSurface: unique(29),
  onInverseSurface: unique(30),
  inversePrimary: unique(31),
  shadow: unique(32),
  scrim: unique(33),
  surfaceTint: unique(34),
);

Color role(String name) => switch (name) {
  'primary' => scheme.primary,
  'onPrimary' => scheme.onPrimary,
  'primaryContainer' => scheme.primaryContainer,
  'onPrimaryContainer' => scheme.onPrimaryContainer,
  'secondaryContainer' => scheme.secondaryContainer,
  'onSecondaryContainer' => scheme.onSecondaryContainer,
  'error' => scheme.error,
  'surface' => scheme.surface,
  'onSurface' => scheme.onSurface,
  'surfaceContainerLow' => scheme.surfaceContainerLow,
  'outline' => scheme.outline,
  _ => throw ArgumentError('Add "$name" to role() in this test'),
};

/// Where each table entry's widget sits in [ColorPreview]. Foreground entries
/// point at the label or icon itself, so the widget's other colours cannot
/// satisfy them.
Finder colorSample(WidgetUsage usage) =>
    switch ((usage.widget, usage.property)) {
      ('FilledButton', 'foregroundColor') => find.text('Filled'),
      ('FilledButton.tonal', 'foregroundColor') => find.text('Tonal'),
      ('OutlinedButton', 'foregroundColor') => find.text('Outlined'),
      ('FloatingActionButton', 'foregroundColor') => find.byIcon(Icons.add),
      ('AppBar', 'foregroundColor') => find.text('AppBar'),
      ('FilterChip', 'labelStyle (selected)') => find.text('FilterChip'),
      ('TextField', 'errorStyle') => find.text('errorText'),
      _ => _widgetSample(usage),
    };

Finder _widgetSample(WidgetUsage usage) => switch (usage.widget) {
  'FilledButton' => find.widgetWithText(FilledButton, 'Filled'),
  'FilledButton.tonal' => find.widgetWithText(FilledButton, 'Tonal'),
  'OutlinedButton' => find.byType(OutlinedButton),
  'Switch' => find.byType(Switch),
  'FloatingActionButton' => find.byType(FloatingActionButton),
  'FilterChip' => find.byType(FilterChip),
  'AppBar' => find.byType(AppBar),
  'Card' => find.byType(Card),
  'TextField' when usage.property == 'errorBorder' => find.ancestor(
    of: find.text('Invalid'),
    matching: find.byType(InputDecorator),
  ),
  'TextField' => find.ancestor(
    of: find.text('Focused'),
    matching: find.byType(InputDecorator),
  ),
  _ => throw ArgumentError(
    'No preview widget for ${usage.widget}.${usage.property}: add one to '
    'ColorPreview and to colorSample() in this test',
  ),
};

/// Every colour painted inside [rect] of [image].
Set<int> colorsIn(Uint8List rgba, int width, Rect rect) {
  final Set<int> found = {};
  for (int y = rect.top.ceil(); y < rect.bottom.floor(); y++) {
    for (int x = rect.left.ceil(); x < rect.right.floor(); x++) {
      final int i = (y * width + x) * 4;
      found.add(0xFF000000 | rgba[i] << 16 | rgba[i + 1] << 8 | rgba[i + 2]);
    }
  }
  return found;
}

/// Unique font sizes, one per style.
const Map<String, double> sizes = {
  'displayLarge': 61,
  'displayMedium': 59,
  'displaySmall': 53,
  'headlineLarge': 47,
  'headlineMedium': 43,
  'headlineSmall': 41,
  'titleLarge': 37,
  'titleMedium': 31,
  'titleSmall': 29,
  'bodyLarge': 23,
  'bodyMedium': 19,
  'bodySmall': 17,
  'labelLarge': 13,
  'labelMedium': 11,
  'labelSmall': 7,
};

final TextTheme textTheme = TextTheme(
  displayLarge: TextStyle(fontSize: sizes['displayLarge']),
  displayMedium: TextStyle(fontSize: sizes['displayMedium']),
  displaySmall: TextStyle(fontSize: sizes['displaySmall']),
  headlineLarge: TextStyle(fontSize: sizes['headlineLarge']),
  headlineMedium: TextStyle(fontSize: sizes['headlineMedium']),
  headlineSmall: TextStyle(fontSize: sizes['headlineSmall']),
  titleLarge: TextStyle(fontSize: sizes['titleLarge']),
  titleMedium: TextStyle(fontSize: sizes['titleMedium']),
  titleSmall: TextStyle(fontSize: sizes['titleSmall']),
  bodyLarge: TextStyle(fontSize: sizes['bodyLarge']),
  bodyMedium: TextStyle(fontSize: sizes['bodyMedium']),
  bodySmall: TextStyle(fontSize: sizes['bodySmall']),
  labelLarge: TextStyle(fontSize: sizes['labelLarge']),
  labelMedium: TextStyle(fontSize: sizes['labelMedium']),
  labelSmall: TextStyle(fontSize: sizes['labelSmall']),
);

/// The font size [TextStylePreview] renders for each table entry.
double? renderedSize(WidgetTester tester, WidgetUsage usage) {
  double? paragraph(Finder text) =>
      tester.renderObject<RenderParagraph>(text.first).text.style?.fontSize;

  return switch ((usage.widget, usage.property)) {
    ('AlertDialog', 'titleTextStyle') => paragraph(find.text('Dialog title')),
    ('AlertDialog', 'contentTextStyle') => paragraph(
      find.text('Dialog content text.'),
    ),
    ('AppBar', 'titleTextStyle') => paragraph(find.text('AppBar title')),
    ('TabBar', 'labelStyle') => paragraph(find.text('Tab')),
    ('TextField', 'style') =>
      tester.widget<EditableText>(find.byType(EditableText)).style.fontSize,
    ('InputDecoration', 'helperStyle') => paragraph(find.text('Helper text')),
    ('ListTile', 'titleTextStyle') => paragraph(find.text('ListTile title')),
    ('ListTile', 'subtitleTextStyle') => paragraph(find.text('Subtitle')),
    ('ListTile', 'leadingAndTrailingTextStyle') => paragraph(
      find.text('12:00'),
    ),
    ('Material', 'default text style') => paragraph(
      find.text('Text with no style inherits the Material default.'),
    ),
    ('FilledButton', 'textStyle') => paragraph(find.text('Button')),
    ('FilterChip', 'labelStyle') => paragraph(find.text('Chip')),
    _ => throw ArgumentError(
      'No preview text for ${usage.widget}.${usage.property}: add one to '
      'TextStylePreview and to renderedSize() in this test',
    ),
  };
}

void main() {
  testWidgets('every colour usage is painted by its preview widget', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final GlobalKey boundaryKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: scheme),
        home: Scaffold(
          body: RepaintBoundary(
            key: boundaryKey,
            child: const SingleChildScrollView(child: ColorPreview()),
          ),
        ),
      ),
    );

    final RenderRepaintBoundary boundary = tester.renderObject(
      find.byKey(boundaryKey),
    );
    final ui.Image image = (await tester.runAsync(boundary.toImage))!;
    final ByteData bytes = (await tester.runAsync<ByteData?>(
      () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
    ))!;
    final Offset origin = tester.getTopLeft(find.byKey(boundaryKey));

    final List<String> wrong = [];
    for (final MapEntry(key: String name, value: usages)
        in kColorUsages.entries) {
      for (final WidgetUsage usage in usages) {
        final Rect rect = tester.getRect(colorSample(usage)).shift(-origin);
        final Set<int> painted = colorsIn(
          bytes.buffer.asUint8List(),
          image.width,
          rect,
        );
        if (!painted.contains(role(name).toARGB32())) {
          wrong.add('${usage.widget}.${usage.property} does not paint $name');
        }
      }
    }
    image.dispose();

    expect(wrong, isEmpty);
  });

  testWidgets('every text style usage is rendered by its preview widget', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(textTheme: textTheme),
        home: const Scaffold(
          body: SingleChildScrollView(child: TextStylePreview()),
        ),
      ),
    );

    final List<String> wrong = [];
    for (final MapEntry(key: String style, value: usages)
        in kTextStyleUsages.entries) {
      for (final WidgetUsage usage in usages) {
        final double? size = renderedSize(tester, usage);
        if (size != sizes[style]) {
          wrong.add(
            '${usage.widget}.${usage.property} renders at $size px, '
            'not $style (${sizes[style]} px)',
          );
        }
      }
    }

    expect(wrong, isEmpty);
  });
}
