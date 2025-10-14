import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_inspector/src/text_theme/text_style_info.dart';
import 'package:theme_inspector/src/text_theme/text_theme_tab.dart';

void main() {
  group('TextThemeTab', () {
    testWidgets('displays all default text styles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const TextThemeTab()),
      );

      expect(find.text('displayLarge'), findsOneWidget);
      expect(find.text('displayMedium'), findsOneWidget);
      expect(find.text('displaySmall'), findsOneWidget);
      expect(find.text('headlineLarge'), findsOneWidget);
      expect(find.text('headlineMedium'), findsOneWidget);
      expect(find.text('headlineSmall'), findsOneWidget);
    });

    testWidgets('displays font sizes for text styles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const TextThemeTab()),
      );

      expect(find.textContaining('px'), findsAtLeastNWidgets(6));
    });

    testWidgets('displays copy buttons for each text style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const TextThemeTab()),
      );

      expect(find.byIcon(Icons.copy), findsAtLeastNWidgets(6));
    });

    testWidgets('includes additional text styles', (tester) async {
      final additionalStyles = [
        TextStyleInfo(
          'customStyle',
          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextStyleInfo(
          'anotherStyle',
          const TextStyle(fontSize: 16, fontFamily: 'CustomFont'),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: TextThemeTab(additionalTextStyles: additionalStyles),
        ),
      );

      expect(find.text('customStyle'), findsOneWidget);
      expect(find.text('anotherStyle'), findsOneWidget);
      expect(find.text('displayLarge'), findsOneWidget);
    });

    testWidgets('handles null text styles gracefully', (tester) async {
      final additionalStyles = [
        TextStyleInfo('nullStyle', null),
        TextStyleInfo('validStyle', const TextStyle(fontSize: 18)),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: TextThemeTab(additionalTextStyles: additionalStyles),
        ),
      );

      expect(find.text('nullStyle'), findsNothing);
      expect(find.text('validStyle'), findsOneWidget);
    });

    testWidgets('displays text styles with correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const TextThemeTab()),
      );

      final textFinder = find.text('displayLarge');
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style, isNotNull);
    });

    testWidgets('renders as a list view with separators', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const TextThemeTab()),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Divider), findsAtLeastNWidgets(5));
    });
  });
}
