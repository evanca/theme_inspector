import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/text_theme/text_theme_tab.dart';

Future<void> pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: TextThemeTab())),
  );
  await tester.pump();
}

void main() {
  // These assert the layout decision rather than the absence of an ellipsis:
  // widget tests use a fixed-width test font whose glyphs are roughly twice the
  // width of the real one, so whether a given specimen fits beside its label at
  // a given width answers differently under test than in the running app.
  //
  // '57px' and '11px' are used as anchors because they are the only font sizes
  // in the Material text theme that belong to exactly one style.
  group('text theme rows', () {
    testWidgets('a specimen too wide for its row drops the label beneath it', (
      tester,
    ) async {
      await pumpAt(tester, const Size(400, 900));

      expect(
        tester.getTopLeft(find.text('57px')).dy,
        greaterThanOrEqualTo(
          tester.getBottomLeft(find.text('displayLarge')).dy,
        ),
        reason: 'displayLarge needs the full width, so its label goes below',
      );
    });

    testWidgets('a narrow specimen keeps its label on the same row', (
      tester,
    ) async {
      // Tall enough for the lazy ListView to build labelSmall, the last row.
      await pumpAt(tester, const Size(400, 4000));

      expect(
        tester.getTopLeft(find.text('11px')).dy,
        lessThan(tester.getBottomLeft(find.text('labelSmall')).dy),
        reason: 'labelSmall has room to sit beside its label',
      );
    });

    testWidgets('the size label is not rendered in the specimen style', (
      tester,
    ) async {
      await pumpAt(tester, const Size(400, 900));

      final RenderParagraph label = tester.renderObject<RenderParagraph>(
        find.text('57px'),
      );
      final RenderParagraph specimen = tester.renderObject<RenderParagraph>(
        find.text('displayLarge'),
      );
      expect(
        label.text.style!.fontSize,
        lessThan(specimen.text.style!.fontSize!),
        reason: 'the px value is metadata, not a specimen of the style',
      );
    });
  });
}
