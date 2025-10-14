import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_inspector/src/color_scheme/color_info.dart';
import 'package:theme_inspector/src/color_scheme/color_scheme_tab.dart';
import 'package:theme_inspector/src/color_scheme/color_section.dart';

void main() {
  group('ColorSchemeTab', () {
    testWidgets('displays default color sections', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const ColorSchemeTab()),
      );

      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.text('Surface'), findsOneWidget);
    });

    testWidgets('displays additional color sections', (tester) async {
      final additionalColors = [
        ColorSection(
          title: 'Custom Colors',
          colors: [
            ColorInfo(name: 'custom1', color: Colors.red),
            ColorInfo(name: 'custom2', color: Colors.blue),
          ],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: ColorSchemeTab(additionalColors: additionalColors),
        ),
      );

      expect(find.text('Custom Colors'), findsOneWidget);
      expect(find.text('Primary'), findsOneWidget);
    });

    testWidgets('displays color names in color cards', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const ColorSchemeTab()),
      );

      expect(find.text('primary'), findsOneWidget);
      expect(find.text('onPrimary'), findsOneWidget);
      expect(find.text('secondary'), findsOneWidget);
      expect(find.text('surface'), findsOneWidget);
    });

    testWidgets('displays hex color values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const ColorSchemeTab()),
      );

      expect(find.textContaining('#'), findsAtLeastNWidgets(6));
    });

    testWidgets('has copy buttons for each color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const ColorSchemeTab()),
      );

      expect(find.byIcon(Icons.copy), findsNWidgets(6));
    });

    testWidgets('handles empty additional colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const ColorSchemeTab(additionalColors: []),
        ),
      );

      expect(find.text('Primary'), findsOneWidget);
    });

    testWidgets('displays custom color info correctly', (tester) async {
      final customColor = ColorInfo(
        name: 'customColor',
        color: Colors.purple,
        textColor: Colors.white,
      );

      final additionalColors = [
        ColorSection(title: 'Custom', colors: [customColor]),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: ColorSchemeTab(additionalColors: additionalColors),
        ),
      );

      expect(find.text('customColor'), findsOneWidget);
      expect(find.text('#9C27B0 100%'), findsOneWidget);
    });

    testWidgets('displays alpha values correctly', (tester) async {
      final quarterAlphaColor = ColorInfo(
        name: 'quarterAlpha',
        color: Colors.red.withValues(alpha: 0.25),
      );

      final threeQuarterAlphaColor = ColorInfo(
        name: 'threeQuarterAlpha',
        color: Colors.blue.withValues(alpha: 0.75),
      );

      final additionalColors = [
        ColorSection(
          title: 'Alpha Test',
          colors: [quarterAlphaColor, threeQuarterAlphaColor],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: ColorSchemeTab(additionalColors: additionalColors),
        ),
      );

      expect(find.text('quarterAlpha'), findsOneWidget);
      expect(find.text('threeQuarterAlpha'), findsOneWidget);
      expect(find.text('#F44336 25%'), findsOneWidget);
      expect(find.text('#2196F3 75%'), findsOneWidget);
    });
  });
}
