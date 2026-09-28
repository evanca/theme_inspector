import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/inspector_page.dart';

const Size phone = Size(390, 844);
const Size desktop = Size(1280, 900);

Future<void> pumpInspector(
  WidgetTester tester,
  Size size, {
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  await tester.pumpWidget(const MaterialApp(home: InspectorPage()));
  await tester.pumpAndSettle();
}

void main() {
  // Overflow is reported as an exception, which fails the test on its own;
  // takeException makes the expectation explicit.
  group('large text on a phone', () {
    testWidgets('colour tiles and the bottom bar lay out at 2x text', (
      tester,
    ) async {
      await pumpInspector(tester, phone, textScale: 2.0);

      expect(tester.takeException(), isNull);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('the where-used sheet lays out at 2x text', (tester) async {
      await pumpInspector(tester, phone, textScale: 2.0);

      await tester.tap(find.text('primary'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('text style rows lay out at 2x text', (tester) async {
      await pumpInspector(tester, phone, textScale: 2.0);

      await tester.tap(find.text('Text'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('displayLarge'), findsOneWidget);
    });
  });

  group('tap targets', () {
    for (final (String name, Size size) in [
      ('bottom bar layout', phone),
      ('rail layout with the where-used panel', desktop),
    ]) {
      testWidgets('meet the Android size guideline in the $name', (
        tester,
      ) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await pumpInspector(tester, size);

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        handle.dispose();
      });

      testWidgets('are all labelled in the $name', (tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await pumpInspector(tester, size);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      });
    }
  });
}
