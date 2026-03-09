import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_inspector/src/inspector_page.dart';
import 'package:theme_inspector/src/theme_inspector_base.dart';

void main() {
  group('InspectorPage Touch Target Accessibility', () {
    final minimalCustomTab = InspectorTab(
      title: 'Test',
      icon: Icons.star,
      child: const SizedBox.shrink(),
    );

    testWidgets(
      'all small-screen tabs have height set to kMinInteractiveDimension',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: InspectorPage()));

        final tabs = tester.widgetList<Tab>(find.byType(Tab)).toList();
        expect(tabs, isNotEmpty);
        for (final tab in tabs) {
          expect(
            tab.height,
            kMinInteractiveDimension,
            reason:
                'All small-screen tabs must have height '
                '$kMinInteractiveDimension dp to meet the minimum '
                'tap-target size and keep icons vertically aligned.',
          );
        }
      },
    );

    testWidgets('on small screens: only the selected tab label is opaque; '
        'others are hidden but keep their layout space', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final tabA = InspectorTab(
        title: 'A',
        icon: Icons.star,
        child: const SizedBox.shrink(),
      );
      final tabB = InspectorTab(
        title: 'B',
        icon: Icons.favorite,
        child: const SizedBox.shrink(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: InspectorPage(
            colorSchemeEnabled: false,
            materialEnabled: false,
            cupertinoEnabled: false,
            textThemeEnabled: false,
            customTabs: [tabA, tabB],
          ),
        ),
      );

      double labelOpacity(int index) =>
          tester
              .widget<Opacity>(find.byKey(ValueKey('tab_label_opacity_$index')))
              .opacity;

      expect(labelOpacity(0), 1.0);
      expect(labelOpacity(1), 0.0);

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      expect(labelOpacity(0), 0.0);
      expect(labelOpacity(1), 1.0);
    });

    testWidgets(
      'icon+text tabs on large screens use default height (height is null)',
      (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MaterialApp(home: InspectorPage()));

        for (final tab in tester.widgetList<Tab>(find.byType(Tab))) {
          expect(tab.height, isNull);
        }
      },
    );

    testWidgets(
      'top bar meets android tap target guidelines on small screens',
      (tester) async {
        final handle = tester.ensureSemantics();

        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: InspectorPage(
              colorSchemeEnabled: false,
              materialEnabled: false,
              cupertinoEnabled: false,
              textThemeEnabled: false,
              customTabs: [minimalCustomTab],
            ),
          ),
        );

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        handle.dispose();
      },
    );

    testWidgets(
      'top bar meets android tap target guidelines on large screens',
      (tester) async {
        final handle = tester.ensureSemantics();

        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: InspectorPage(
              colorSchemeEnabled: false,
              materialEnabled: false,
              cupertinoEnabled: false,
              textThemeEnabled: false,
              customTabs: [minimalCustomTab],
            ),
          ),
        );

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        handle.dispose();
      },
    );
  });

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
