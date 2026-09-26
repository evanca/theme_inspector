import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/color_scheme/color_scheme_tab.dart';
import 'package:theme_inspector/theme_inspector.dart';

const String kName = 'Custom Color 1';

Future<void> pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ColorSchemeTab(
          additionalColors: [
            ColorSection(
              title: 'My custom colors',
              colors: [
                ColorInfo(
                  name: kName,
                  color: const Color(0xFF0057B7),
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
}

/// Whether the name is laid out with room for all of its glyphs, i.e. the
/// ellipsis has not kicked in.
///
/// Only meaningful in the stacked layout, where the name gets the full card
/// width. Widget tests render with a fixed-width test font whose glyphs are far
/// wider than the real one, so whether a given name fits beside the hex chip at
/// a given width differs from the running app.
void expectNameNotTruncated(WidgetTester tester) {
  final RenderParagraph paragraph = tester.renderObject<RenderParagraph>(
    find.text(kName),
  );
  expect(
    paragraph.size.width,
    greaterThanOrEqualTo(paragraph.getMaxIntrinsicWidth(double.infinity) - 0.5),
    reason: 'the colour name must not be ellipsised',
  );
}

void main() {
  group('colour row layout', () {
    testWidgets('stacks name above value on a narrow phone', (tester) async {
      await pumpAt(tester, const Size(320, 568));

      expectNameNotTruncated(tester);
      expect(
        tester.getTopLeft(find.textContaining('#0057B7')).dy,
        greaterThan(tester.getBottomLeft(find.text(kName)).dy),
        reason: 'the hex chip must sit below the name, not beside it',
      );
    });

    testWidgets('keeps name and value on one row at 390', (tester) async {
      await pumpAt(tester, const Size(390, 844));

      expect(
        tester.getTopLeft(find.textContaining('#0057B7')).dy,
        lessThan(tester.getBottomLeft(find.text(kName)).dy),
        reason: 'there is room for a single row at this width',
      );
    });

    testWidgets('keeps name and value on one row on a tablet', (tester) async {
      await pumpAt(tester, const Size(768, 1024));

      expect(
        tester.getTopLeft(find.textContaining('#0057B7')).dy,
        lessThan(tester.getBottomLeft(find.text(kName)).dy),
      );
    });
  });
}
