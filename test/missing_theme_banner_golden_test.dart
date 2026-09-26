@Tags(['golden'])
library;

import 'dart:ui' show Size;

import 'package:flutter/material.dart' as legacy;
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_inspector/src/shared/missing_theme_banner.dart';

void main() {
  group('MissingThemeBanner golden', () {
    // This screen renders without a Scaffold or Material ancestor on purpose,
    // so it is unusually easy to regress visually: inherited debug styling
    // (yellow underlines) does not fail any behavioural assertion.
    for (final (String name, Size size) in const [
      ('phone', Size(420, 820)),
      ('wide', Size(900, 700)),
    ]) {
      testWidgets('renders correctly at $name', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        // A legacy MaterialApp is the situation the screen exists for.
        await tester.pumpWidget(
          const legacy.MaterialApp(home: MissingThemeBanner()),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MissingThemeBanner),
          matchesGoldenFile('goldens/missing_theme_banner_$name.png'),
        );
      });
    }
  });
}
