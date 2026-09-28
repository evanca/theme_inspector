import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/inspector_page.dart';
import 'package:theme_inspector/theme_inspector.dart';

/// Pumps the inspector at a fixed logical size.
Future<void> pumpAt(
  WidgetTester tester,
  Size size, {
  List<InspectorTab>? customTabs,
  bool builtInTabs = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: InspectorPage(
        customTabs: customTabs,
        colorSchemeEnabled: builtInTabs,
        materialEnabled: builtInTabs,
        cupertinoEnabled: builtInTabs,
        textThemeEnabled: builtInTabs,
      ),
    ),
  );
  await tester.pump();
}

List<InspectorTab> extraTabs(int n) => List.generate(
  n,
  (i) => InspectorTab(
    title: 'Extra $i',
    icon: Icons.star,
    child: Text('Extra body $i'),
  ),
);

void main() {
  group('navigation follows the window size class', () {
    testWidgets('a rail from 600 dp', (tester) async {
      await pumpAt(tester, const Size(600, 900));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('a bottom bar just below 600 dp', (tester) async {
      await pumpAt(tester, const Size(599, 900));
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('a scrollable tab bar on a phone with more than five tabs', (
      tester,
    ) async {
      await pumpAt(tester, const Size(390, 844), customTabs: extraTabs(2));
      expect(find.byType(NavigationBar), findsNothing);
      expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isTrue);
    });

    testWidgets('a rail for eight tabs on a short landscape window', (
      tester,
    ) async {
      // Eight destinations are taller than 400 dp; the rail must scroll
      // rather than overflow.
      await pumpAt(tester, const Size(900, 400), customTabs: extraTabs(4));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('no navigation for a single tab', (tester) async {
      await pumpAt(
        tester,
        const Size(390, 844),
        builtInTabs: false,
        customTabs: extraTabs(1),
      );
      expect(find.text('Extra body 0'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(TabBar), findsNothing);
    });
  });

  group('selecting a destination shows its tab', () {
    testWidgets('from the bottom bar, retitling the app bar', (tester) async {
      await pumpAt(tester, const Size(390, 844));
      expect(find.widgetWithText(AppBar, 'Color Scheme'), findsOneWidget);

      await tester.tap(find.text('Text'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Text Theme'), findsOneWidget);
      expect(find.text('displayLarge'), findsOneWidget);
      expect(find.text('Primary'), findsNothing);
    });

    testWidgets('from the rail, retitling the page', (tester) async {
      await pumpAt(tester, const Size(1280, 900), customTabs: extraTabs(1));

      await tester.tap(find.text('Extra 0'));
      await tester.pumpAndSettle();

      expect(find.text('Extra body 0'), findsOneWidget);
      expect(find.text('Color Scheme'), findsNothing);
    });
  });

  group('the selected tab survives a layout change', () {
    testWidgets('from bottom bar to rail, as when a tablet rotates', (
      tester,
    ) async {
      await pumpAt(tester, const Size(390, 844));
      await tester.tap(find.text('Text'));
      await tester.pumpAndSettle();

      tester.view.physicalSize = const Size(1024, 768);
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(
        tester
            .widget<NavigationRail>(find.byType(NavigationRail))
            .selectedIndex,
        3,
      );
      expect(find.text('Text Theme'), findsOneWidget);
    });

    testWidgets('from rail to compact tab bar', (tester) async {
      await pumpAt(tester, const Size(1024, 768), customTabs: extraTabs(2));
      await tester.tap(find.text('Extra 1'));
      await tester.pumpAndSettle();

      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();

      expect(find.text('Extra body 1'), findsOneWidget);
      expect(find.text('Extra body 0'), findsNothing);
    });
  });

  group('compact tab labels stay accessible', () {
    testWidgets('unselected tabs keep a semantic label', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await pumpAt(tester, const Size(390, 844), customTabs: extraTabs(2));

      // Tab 0 is selected; the others are faded to zero opacity, which used
      // to drop them from the semantics tree entirely.
      const List<String> titles = [
        'Color Scheme',
        'Material',
        'Cupertino',
        'Text Theme',
        'Extra 0',
        'Extra 1',
      ];
      for (int i = 0; i < titles.length; i++) {
        expect(
          tester.getSemantics(find.byType(Tab).at(i)).label,
          contains(titles[i]),
          reason: '"${titles[i]}" must be announced even when unselected',
        );
      }

      handle.dispose();
    });
  });
}
