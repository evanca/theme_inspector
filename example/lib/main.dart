import 'package:flutter/material.dart';
import 'package:theme_inspector/theme_inspector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Inspector Example',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final gradientButton = Container(
      height: 44.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0057B7), Color(0xFFFFDD00)],
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text('My Custom Button', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Theme Inspector',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Press the button below to open the inspector',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  () => ThemeInspector.open(
                    context,
                    additionalColors: [
                      ColorSection(
                        title: "My custom colors",
                        colors: [
                          ColorInfo(
                            name: 'Custom Color 1',
                            color: Color(0xFF0057B7),
                            textColor: Colors.white,
                          ),
                          ColorInfo(
                            name: 'Custom Color 2',
                            color: Color(0xFFFFDD00),
                            textColor: Colors.black,
                          ),
                        ],
                      ),
                    ],
                    additionalTextStyles: [
                      TextStyleInfo(
                        'My Custom Style 1',
                        TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0057B7),
                        ),
                      ),
                      TextStyleInfo(
                        'My Custom Style 2',
                        TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF9D2235),
                        ),
                      ),
                    ],
                    additionalMaterialWidgets: [
                      SectionWrapper(
                        title: 'My Custom Widget for Material Tab',
                        child: gradientButton,
                      ),
                    ],
                    additionalCupertinoWidgets: [
                      SectionWrapper(
                        title: 'My Custom Widget for Cupertino Tab',
                        child: gradientButton,
                      ),
                    ],
                    customTabs: [
                      InspectorTab(
                        title: 'My Custom Tab',
                        icon: Icons.catching_pokemon,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'This is a custom tab added to the Theme Inspector. You can add any content here.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
              child: const Text('Open Theme Inspector'),
            ),
          ],
        ),
      ),
    );
  }
}
