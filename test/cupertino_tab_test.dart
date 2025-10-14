import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_inspector/src/cupertino/cupertino_tab.dart';
import 'package:theme_inspector/src/shared/section_wrapper.dart';

void main() {
  group('CupertinoTab', () {
    testWidgets('displays navigation bar with correct title', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(find.text('CupertinoNavigationBar'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.ellipsis), findsOneWidget);
    });

    testWidgets('displays tab bar with navigation items', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(find.byType(CupertinoTabBar), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.home), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.plus_app), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.gear), findsOneWidget);
      expect(find.text('Label'), findsAtLeastNWidgets(3));
    });

    testWidgets('displays all default sections', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(find.text('Buttons'), findsOneWidget);
      expect(find.text('Text Fields'), findsOneWidget);
      expect(find.text('Controls'), findsOneWidget);
      expect(find.text('List Components'), findsOneWidget);
      expect(find.text('Cupertino Form'), findsOneWidget);
      expect(find.text('Selection'), findsOneWidget);
      expect(find.text('Color Constants'), findsOneWidget);
      expect(find.text('Bottom Sheets'), findsOneWidget);
    });

    testWidgets('displays button widgets', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(find.text('Button'), findsOneWidget);
      expect(find.text('Filled'), findsOneWidget);
      expect(find.text('Disabled'), findsWidgets); // Multiple disabled elements
      expect(find.text('Tinted'), findsOneWidget);
    });

    testWidgets('displays text field widgets', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(find.text('Basic'), findsOneWidget);
      expect(find.text('Disabled'), findsWidgets); // Multiple disabled elements
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('displays control widgets', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(
        find.byType(CupertinoSlidingSegmentedControl<int>),
        findsOneWidget,
      );
      expect(find.byType(CupertinoSlider), findsOneWidget);
      expect(find.byType(CupertinoSwitch), findsWidgets);
      expect(find.byType(CupertinoCheckbox), findsWidgets);
    });

    testWidgets('displays list components', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(find.byType(CupertinoListTile), findsAtLeastNWidgets(2));
    });

    testWidgets('displays form components', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(find.byType(CupertinoTextFormFieldRow), findsAtLeastNWidgets(1));
    });

    testWidgets('displays selection controls', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(find.byType(CupertinoSwitch), findsAtLeastNWidgets(1));
      expect(find.byType(CupertinoCheckbox), findsAtLeastNWidgets(1));
    });

    testWidgets('displays color constants', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      // The color constants section should display some color names
      expect(find.textContaining('system'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays bottom sheet widgets', (tester) async {
      await tester.pumpWidget(CupertinoApp(home: const CupertinoTab()));

      expect(find.text('Show Action Sheet'), findsOneWidget);
      expect(find.text('Show Bottom Sheet'), findsOneWidget);
    });

    testWidgets('includes additional cupertino widgets', (tester) async {
      final additionalWidgets = [
        SectionWrapper(
          title: 'Custom Widget',
          child: Container(
            width: 100,
            height: 100,
            color: CupertinoColors.activeBlue,
            child: const Text('Custom'),
          ),
        ),
      ];

      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoTab(additionalCupertinoWidgets: additionalWidgets),
        ),
      );

      expect(find.text('Custom Widget'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);
      expect(
        find.text('Buttons'),
        findsOneWidget,
      ); // Default sections still present
    });

    testWidgets('handles empty additional widgets', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(home: const CupertinoTab(additionalCupertinoWidgets: [])),
      );

      expect(find.text('Buttons'), findsOneWidget);
    });
  });
}
