import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_inspector/src/inspector_page.dart';
import 'package:theme_inspector/src/theme_inspector_base.dart';

void main() {
  group('InspectorPage Tab Visibility', () {
    testWidgets('shows all tabs when all enabled flags are true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InspectorPage(
            materialEnabled: true,
            cupertinoEnabled: true,
            colorSchemeEnabled: true,
            textThemeEnabled: true,
          ),
        ),
      );

      // Verify all default tabs are present
      expect(find.text('Color Scheme'), findsOneWidget);
      expect(find.text('Material'), findsOneWidget);
      expect(find.text('Cupertino'), findsOneWidget);
      expect(find.text('Text Theme'), findsOneWidget);
    });

    testWidgets('hides tabs when corresponding flags are false', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InspectorPage(
            materialEnabled: false,
            cupertinoEnabled: false,
            colorSchemeEnabled: false,
            textThemeEnabled: false,
          ),
        ),
      );

      // Verify no default tabs are present
      expect(find.text('Color Scheme'), findsNothing);
      expect(find.text('Material'), findsNothing);
      expect(find.text('Cupertino'), findsNothing);
      expect(find.text('Text Theme'), findsNothing);
    });

    testWidgets('shows only enabled tabs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InspectorPage(
            materialEnabled: true,
            cupertinoEnabled: false,
            colorSchemeEnabled: true,
            textThemeEnabled: false,
          ),
        ),
      );

      // Verify only enabled tabs are present
      expect(find.text('Color Scheme'), findsOneWidget);
      expect(find.text('Material'), findsOneWidget);
      expect(find.text('Cupertino'), findsNothing);
      expect(find.text('Text Theme'), findsNothing);
    });

    testWidgets('includes custom tabs regardless of default tab flags', (
      tester,
    ) async {
      final customTab = InspectorTab(
        title: 'Custom',
        icon: Icons.star,
        child: Container(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: InspectorPage(
            materialEnabled: false,
            cupertinoEnabled: false,
            colorSchemeEnabled: false,
            textThemeEnabled: false,
            customTabs: [customTab],
          ),
        ),
      );

      // Verify custom tab is present even when all default tabs are disabled
      expect(find.text('Custom'), findsOneWidget);
      expect(find.text('Color Scheme'), findsNothing);
      expect(find.text('Material'), findsNothing);
      expect(find.text('Cupertino'), findsNothing);
      expect(find.text('Text Theme'), findsNothing);
    });
  });
}
