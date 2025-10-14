import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_inspector/src/material/material_tab.dart';
import 'package:theme_inspector/src/shared/section_wrapper.dart';

void main() {
  group('MaterialTab', () {
    testWidgets('displays app bar with correct title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const MaterialTab()),
      );

      expect(find.text('AppBar'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('displays bottom navigation bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const MaterialTab()),
      );

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Label'), findsAtLeastNWidgets(3));
    });

    testWidgets('displays all default sections', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const MaterialTab()),
      );

      expect(find.text('Buttons'), findsOneWidget);
      expect(find.text('Text Fields'), findsOneWidget);
      expect(find.text('Controls'), findsOneWidget);
      expect(find.text('List Components'), findsOneWidget);
      expect(find.text('Selection'), findsOneWidget);
      expect(find.text('Cards'), findsOneWidget);
      expect(find.text('Bottom Sheets'), findsOneWidget);
    });

    testWidgets('displays button widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const MaterialTab()),
      );

      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(2));
      expect(find.text('Elevated'), findsOneWidget);
      expect(find.text('Filled'), findsOneWidget);
      expect(find.text('Outlined'), findsOneWidget);
      expect(find.text('Text'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsAtLeastNWidgets(2));
    });

    testWidgets('displays text field widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const MaterialTab()),
      );

      expect(find.byType(TextField), findsAtLeastNWidgets(3));
      expect(find.text('Basic'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('displays control widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const MaterialTab()),
      );

      expect(find.byType(Switch), findsAtLeastNWidgets(3));
      expect(find.byType(Checkbox), findsAtLeastNWidgets(3));
    });

    testWidgets('displays list components', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const MaterialTab()),
      );

      expect(find.byType(ListTile), findsAtLeastNWidgets(3));
    });

    testWidgets('displays card widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const MaterialTab()),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('displays bottom sheet widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const MaterialTab()),
      );

      expect(find.text('Show Modal Bottom Sheet'), findsOneWidget);
      expect(find.text('Show Persistent Bottom Sheet'), findsOneWidget);
    });

    testWidgets('includes additional material widgets', (tester) async {
      final additionalWidgets = [
        SectionWrapper(
          title: 'Custom Widget',
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: const Text('Custom'),
          ),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: MaterialTab(additionalMaterialWidgets: additionalWidgets),
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
        MaterialApp(
          theme: ThemeData.light(),
          home: const MaterialTab(additionalMaterialWidgets: []),
        ),
      );

      expect(find.text('Buttons'), findsOneWidget);
    });
  });
}
