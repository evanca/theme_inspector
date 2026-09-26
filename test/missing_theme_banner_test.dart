import 'package:flutter/material.dart' as legacy;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/inspector_page.dart';
import 'package:theme_inspector/theme_inspector.dart';
import 'package:theme_inspector/src/shared/missing_theme_banner.dart';

void main() {
  group('MissingThemeBanner', () {
    testWidgets('is not shown when the app provides a material_ui theme', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: InspectorPage()));

      expect(find.byType(MissingThemeBanner), findsNothing);
    });

    testWidgets('is shown when the host app has not migrated', (tester) async {
      // A legacy MaterialApp provides package:flutter/material.dart's Theme,
      // which the inspector cannot read since 2.0.0.
      await tester.pumpWidget(const legacy.MaterialApp(home: InspectorPage()));

      expect(find.byType(MissingThemeBanner), findsOneWidget);
      expect(find.textContaining('No material_ui theme found'), findsOneWidget);
    });

    testWidgets('ThemeInspector.open shows the notice in a legacy app', (
      tester,
    ) async {
      await tester.pumpWidget(
        legacy.MaterialApp(
          home: legacy.Builder(
            builder: (context) => legacy.ElevatedButton(
              onPressed: () => ThemeInspector.open(context),
              child: const legacy.Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(MissingThemeBanner), findsOneWidget);
    });

    testWidgets('hasMaterialUiTheme discriminates between the libraries', (
      tester,
    ) async {
      final List<bool> results = <bool>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              results.add(hasMaterialUiTheme(context));
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpWidget(
        legacy.MaterialApp(
          home: legacy.Builder(
            builder: (context) {
              results.add(hasMaterialUiTheme(context));
              return const SizedBox();
            },
          ),
        ),
      );

      expect(results, <bool>[true, false]);
    });
  });
}
