import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/text_theme/text_style_info.dart';
import 'package:theme_inspector/src/text_theme/text_theme_tab.dart';

/// A phone: "where used" opens as a bottom sheet. Tall so the lazy list
/// builds every row.
const Size phone = Size(390, 4000);

/// A desktop window: the list sits beside the "where used" panel.
const Size desktop = Size(1280, 4000);

Future<void> pumpTab(
  WidgetTester tester,
  Size size, {
  List<TextStyleInfo>? additionalTextStyles,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: TextThemeTab(additionalTextStyles: additionalTextStyles),
      ),
    ),
  );
}

void main() {
  group('rows', () {
    testWidgets('groups the fifteen styles by role, in scale order', (
      tester,
    ) async {
      await pumpTab(tester, phone);

      double top(String text) => tester.getTopLeft(find.text(text)).dy;
      const List<String> order = [
        'Display',
        'displayLarge',
        'displaySmall',
        'Headline',
        'headlineSmall',
        'Title',
        'titleSmall',
        'Body',
        'bodySmall',
        'Label',
        'labelSmall',
      ];
      for (int i = 1; i < order.length; i++) {
        expect(
          top(order[i]),
          greaterThan(top(order[i - 1])),
          reason: '${order[i]} must come after ${order[i - 1]}',
        );
      }
    });

    testWidgets('shows each style\'s size and weight', (tester) async {
      await pumpTab(tester, phone);

      // Material 3 sets labelLarge at 14 px, weight 500.
      final Finder row = find.ancestor(
        of: find.text('labelLarge'),
        matching: find.byType(InkWell),
      );
      expect(
        find.descendant(of: row, matching: find.text('14px')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: row, matching: find.text('w500')),
        findsOneWidget,
      );
    });

    testWidgets('puts custom styles first, under their own heading', (
      tester,
    ) async {
      await pumpTab(
        tester,
        phone,
        additionalTextStyles: const [
          TextStyleInfo('brandHeading', TextStyle(fontSize: 20)),
        ],
      );

      expect(
        tester.getTopLeft(find.text('brandHeading')).dy,
        lessThan(tester.getTopLeft(find.text('displayLarge')).dy),
      );
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('skips styles the theme leaves null', (tester) async {
      await pumpTab(
        tester,
        phone,
        additionalTextStyles: const [
          TextStyleInfo('nullStyle', null),
          TextStyleInfo('validStyle', TextStyle(fontSize: 18)),
        ],
      );

      expect(find.text('nullStyle'), findsNothing);
      expect(find.text('validStyle'), findsOneWidget);
    });

    testWidgets('has a copy button on every row', (tester) async {
      await pumpTab(tester, phone);

      expect(find.byIcon(Icons.copy), findsNWidgets(15));
    });
  });

  group('where used', () {
    testWidgets('shows bodyLarge in the side panel on a desktop', (
      tester,
    ) async {
      await pumpTab(tester, desktop);

      expect(find.text('WHERE USED'), findsOneWidget);
      expect(find.text('TextField'), findsOneWidget);
      expect(find.text('titleTextStyle'), findsOneWidget); // ListTile
    });

    testWidgets('follows the selected row', (tester) async {
      await pumpTab(tester, desktop);

      await tester.tap(find.text('labelLarge'));
      await tester.pumpAndSettle();

      expect(find.text('FilterChip'), findsOneWidget);
      expect(find.text('TextField'), findsNothing);
    });

    testWidgets('says so when no preview widget uses the style', (
      tester,
    ) async {
      await pumpTab(tester, desktop);

      await tester.tap(find.text('displayLarge'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'None of the widgets in this preview use this style by default.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('opens a bottom sheet for the tapped row on a phone', (
      tester,
    ) async {
      await pumpTab(tester, phone);
      expect(find.text('WHERE USED'), findsNothing);

      await tester.tap(find.text('titleLarge'));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.text('AppBar'), findsOneWidget);
    });
  });
}
