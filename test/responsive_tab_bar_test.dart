import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/inspector_page.dart';
import 'package:theme_inspector/theme_inspector.dart';

/// Pumps the inspector at a fixed logical size.
Future<void> pumpAt(
  WidgetTester tester,
  Size size, {
  List<InspectorTab>? customTabs,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(home: InspectorPage(customTabs: customTabs)),
  );
  await tester.pump();
}

List<InspectorTab> extraTabs(int n) => List.generate(
  n,
  (i) => InspectorTab(
    title: 'Extra $i',
    icon: Icons.star,
    child: const SizedBox(),
  ),
);

void main() {
  group('tab bar breakpoint scales with tab count', () {
    testWidgets('4 built-in tabs stay expanded at 600', (tester) async {
      await pumpAt(tester, const Size(600, 900));
      expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isFalse);
    });

    testWidgets('4 built-in tabs go compact just below 600', (tester) async {
      await pumpAt(tester, const Size(599, 900));
      expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isTrue);
    });

    testWidgets('5 tabs stay compact at 601, where labels used to clip', (
      tester,
    ) async {
      await pumpAt(tester, const Size(601, 900), customTabs: extraTabs(1));
      expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isTrue);
    });

    testWidgets('5 tabs expand once there is room at 750', (tester) async {
      await pumpAt(tester, const Size(750, 900), customTabs: extraTabs(1));
      expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isFalse);
    });

    testWidgets('8 tabs stay compact even on a wide laptop screen', (
      tester,
    ) async {
      await pumpAt(tester, const Size(1100, 900), customTabs: extraTabs(4));
      expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isTrue);
    });
  });

  group('compact tab labels stay accessible', () {
    testWidgets('unselected tabs keep a semantic label', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await pumpAt(tester, const Size(390, 844));

      // Tab 0 is selected; the other three are faded to zero opacity, which
      // used to drop them from the semantics tree entirely.
      const List<String> titles = [
        'Color Scheme',
        'Material',
        'Cupertino',
        'Text Theme',
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
