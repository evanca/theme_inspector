import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/src/color_scheme/color_info.dart';
import 'package:theme_inspector/src/color_scheme/color_scheme_tab.dart';
import 'package:theme_inspector/src/color_scheme/color_section.dart';

/// A phone: tiles in one column, "where used" opens as a bottom sheet.
const Size phone = Size(390, 4000);

/// A desktop window: tiles in a grid beside the "where used" panel. Tall so
/// the lazy list builds every section.
const Size desktop = Size(1280, 4000);

const ColorSection brand = ColorSection(
  title: 'Brand',
  colors: [
    ColorInfo(
      name: 'Brand purple',
      color: Color(0xFF6750A4),
      textColor: Color(0xFFFFFFFF),
      textColorName: 'white',
    ),
  ],
);

Future<void> pumpTab(
  WidgetTester tester,
  Size size, {
  List<ColorSection>? additionalColors,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(body: ColorSchemeTab(additionalColors: additionalColors)),
    ),
  );
}

Finder tile(String name) =>
    find.ancestor(of: find.text(name), matching: find.byType(InkWell));

void main() {
  group('tiles', () {
    testWidgets('lists custom sections before the built-in roles', (
      tester,
    ) async {
      await pumpTab(tester, phone, additionalColors: [brand]);

      final double brandY = tester.getTopLeft(find.text('Brand')).dy;
      for (final String section in [
        'Primary',
        'Secondary',
        'Tertiary',
        'Error',
        'Surface',
        'Outline',
      ]) {
        expect(tester.getTopLeft(find.text(section)).dy, greaterThan(brandY));
      }
    });

    testWidgets('pairs each role with its on-colour on one tile', (
      tester,
    ) async {
      await pumpTab(tester, phone);

      final Color onPrimary = ThemeData.light().colorScheme.onPrimary;
      final String hex = onPrimary == const Color(0xFFFFFFFF)
          ? '#FFFFFF 100%'
          : fail('the test assumes the light theme draws white on primary');
      expect(
        find.descendant(
          of: tile('primary'),
          matching: find.text('onPrimary · $hex'),
        ),
        findsOneWidget,
      );
      // The on-colour is no longer a tile of its own.
      expect(find.text('onPrimary'), findsNothing);
    });

    testWidgets('shows the hex value with opacity', (tester) async {
      await pumpTab(
        tester,
        phone,
        additionalColors: [
          ColorSection(
            title: 'Alpha',
            colors: [
              ColorInfo(name: 'opaque', color: Colors.purple),
              ColorInfo(
                name: 'quarter',
                color: Colors.red.withValues(alpha: 0.25),
              ),
            ],
          ),
        ],
      );

      expect(find.text('#9C27B0 100%'), findsOneWidget);
      expect(find.text('#F44336 25%'), findsOneWidget);
    });

    testWidgets('grades the contrast between a colour and its text colour', (
      tester,
    ) async {
      await pumpTab(tester, phone, additionalColors: [brand]);

      // #6750A4 with white is 6.4:1: above AA's 4.5, below AAA's 7.
      expect(
        find.descendant(
          of: tile('Brand purple'),
          matching: find.text('6.4 AA'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('counts preview usages for built-in roles only', (
      tester,
    ) async {
      await pumpTab(tester, phone, additionalColors: [brand]);

      // primary: FilledButton, OutlinedButton, Switch and TextField;
      // onPrimary: FilledButton and Switch.
      expect(
        find.descendant(of: tile('primary'), matching: find.text('6 uses')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: tile('Brand purple'),
          matching: find.textContaining('use'),
        ),
        findsNothing,
      );
    });

    testWidgets('has a copy button on every tile', (tester) async {
      await pumpTab(tester, phone, additionalColors: [brand]);

      // 12 built-in roles plus the custom colour.
      expect(find.byIcon(Icons.copy), findsNWidgets(13));
    });

    testWidgets('copies the colour\'s name and hex value to the clipboard', (
      tester,
    ) async {
      // The platform clipboard is the one real boundary here; record what
      // reaches it.
      final List<String> clipboard = [];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            clipboard.add((call.arguments as Map)['text'] as String);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pumpTab(tester, phone, additionalColors: [brand]);

      await tester.tap(find.byTooltip('Copy Brand purple'));
      await tester.pump();

      expect(clipboard, ['Brand purple: #6750A4 100%']);
      expect(
        find.text('Brand purple: #6750A4 100% copied to clipboard'),
        findsOneWidget,
      );
      // Copying is not selecting: no where-used sheet opens.
      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets('lets a long name wrap instead of truncating it', (
      tester,
    ) async {
      const String name = 'A deliberately long custom colour name';
      await pumpTab(
        tester,
        const Size(320, 4000),
        additionalColors: [
          const ColorSection(
            title: 'Long',
            colors: [ColorInfo(name: name, color: Color(0xFF0057B7))],
          ),
        ],
      );

      final RenderParagraph paragraph = tester.renderObject(find.text(name));
      expect(paragraph.didExceedMaxLines, isFalse);
      expect(tester.takeException(), isNull);
    });
  });

  group('grid', () {
    testWidgets('stacks tiles in one column on a phone', (tester) async {
      await pumpTab(tester, phone);

      expect(
        tester.getTopLeft(tile('primaryContainer')).dy,
        greaterThan(tester.getBottomLeft(tile('primary')).dy),
      );
    });

    testWidgets('puts tiles side by side on a desktop', (tester) async {
      await pumpTab(tester, desktop);

      expect(
        tester.getTopLeft(tile('primaryContainer')).dy,
        tester.getTopLeft(tile('primary')).dy,
      );
    });
  });

  group('where used, desktop', () {
    testWidgets('shows primary in the side panel before any selection', (
      tester,
    ) async {
      await pumpTab(tester, desktop);

      expect(find.text('WHERE USED'), findsOneWidget);
      expect(find.text('backgroundColor: primary'), findsOneWidget);
      expect(find.text('thumbColor (selected): onPrimary'), findsOneWidget);
    });

    testWidgets('follows the selected tile', (tester) async {
      await pumpTab(tester, desktop);

      await tester.tap(find.text('error'));
      await tester.pumpAndSettle();

      expect(find.text('errorBorder: error'), findsOneWidget);
      expect(find.text('backgroundColor: primary'), findsNothing);
    });

    testWidgets('explains that custom colours are not read by widgets', (
      tester,
    ) async {
      await pumpTab(tester, desktop, additionalColors: [brand]);

      await tester.tap(find.text('Brand purple'));
      await tester.pumpAndSettle();

      expect(find.textContaining('This is your own colour'), findsOneWidget);
    });
  });

  group('where used, phone', () {
    testWidgets('has no side panel until a tile is tapped', (tester) async {
      await pumpTab(tester, phone);

      expect(find.text('WHERE USED'), findsNothing);
    });

    testWidgets('opens a bottom sheet for the tapped tile', (tester) async {
      await pumpTab(tester, phone);

      await tester.tap(find.text('secondaryContainer'));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.text('backgroundColor: secondaryContainer'), findsOneWidget);
    });
  });
}
