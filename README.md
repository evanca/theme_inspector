# Theme Inspector

A Flutter package that provides an interactive inspector for visualizing and debugging your app's themes, including Material and Cupertino widgets, color schemes, and text styles.

<p align="center">
  <img src="https://raw.githubusercontent.com/evanca/theme_inspector/refs/heads/main/screenshots/demo.gif" alt="Demo" height="420px" />
</p>

## Features

✨ **Visual Theme Inspection** - View all Material and Cupertino widgets with your current theme applied  
🎨 **Color Scheme Explorer** - Browse and copy color codes from your ColorScheme  
📝 **Text Theme Preview** - See all text styles with size and weight information  
🔧 **Fully Customizable** - Add custom colors, text styles, widgets, and entire tabs  
📋 **Copy to Clipboard** - Easily copy color codes and text style information  
🎛️ **Toggle Tabs** - Enable or disable built-in tabs as needed

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  theme_inspector: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

Import the package and open the inspector:

```dart
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
      home: Scaffold(
        appBar: AppBar(title: const Text('Theme Inspector Demo')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => ThemeInspector.open(context),
            child: const Text('Open Theme Inspector'),
          ),
        ),
      ),
    );
  }
}
```

## Usage

### Basic Usage

Simply call `ThemeInspector.open(context)` to display the inspector with all default tabs:

```dart
ElevatedButton(
  onPressed: () => ThemeInspector.open(context),
  child: const Text('Open Theme Inspector'),
)
```

This will open a page with four default tabs:

- **Color Scheme** - All ColorScheme colors with copy-to-clipboard functionality
- **Material** - Material widgets (buttons, text fields, cards, etc.)
- **Cupertino** - iOS-style Cupertino widgets
- **Text Theme** - All TextTheme styles with size information

### Adding Custom Colors

Display your custom color palette alongside the default ColorScheme:

![Color Scheme Tab](https://raw.githubusercontent.com/evanca/theme_inspector/refs/heads/main/screenshots/web_01_color_scheme.png)

```dart
import 'package:theme_inspector/theme_inspector.dart';

ThemeInspector.open(
  context,
  additionalColors: [
    ColorSection(
      title: "My custom colors",
      colors: [
        ColorInfo(
          name: 'Custom Color 1',
          color: const Color(0xFF0057B7),
          textColor: Colors.white,
        ),
        ColorInfo(
          name: 'Custom Color 2',
          color: const Color(0xFFFFDD00),
          textColor: Colors.black,
        ),
      ],
    ),
  ],
);
```

### Adding Custom Text Styles

Show your custom typography alongside the default TextTheme:

![Text Theme Tab](https://raw.githubusercontent.com/evanca/theme_inspector/refs/heads/main/screenshots/web_02_text_theme.png)

```dart
ThemeInspector.open(
  context,
  additionalTextStyles: [
    TextStyleInfo(
      'My Custom Style 1',
      const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0057B7),
      ),
    ),
    TextStyleInfo(
      'My Custom Style 2',
      const TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: Color(0xFF9D2235),
      ),
    ),
  ],
);
```

### Adding Custom Widgets to Material Tab

Display your custom Material widgets to see how they look with the current theme:

![Material Widgets Tab](https://raw.githubusercontent.com/evanca/theme_inspector/refs/heads/main/screenshots/web_03_material_widgets.png)

```dart
final gradientButton = Container(
  height: 44.0,
  decoration: BoxDecoration(
    gradient: const LinearGradient(
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
    child: const Text(
      'My Custom Button',
      style: TextStyle(color: Colors.white),
    ),
  ),
);

ThemeInspector.open(
  context,
  additionalMaterialWidgets: [
    SectionWrapper(
      title: 'My Custom Widget for Material Tab',
      child: gradientButton,
    ),
  ],
);
```

### Adding Custom Widgets to Cupertino Tab

Display your custom Cupertino widgets:

![Cupertino Widgets Tab](https://raw.githubusercontent.com/evanca/theme_inspector/refs/heads/main/screenshots/web_04_cupertino_widgets.png)

```dart
ThemeInspector.open(
  context,
  additionalCupertinoWidgets: [
    SectionWrapper(
      title: 'My Custom Widget for Cupertino Tab',
      child: gradientButton,
    ),
  ],
);
```

### Creating Custom Tabs

Add completely custom tabs with your own content:

![Custom Tabs Example](https://raw.githubusercontent.com/evanca/theme_inspector/refs/heads/main/screenshots/web_05_custom_tabs.png)

```dart
ThemeInspector.open(
  context,
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
);
```

### Disabling Default Tabs

You can disable any of the built-in tabs:

```dart
ThemeInspector.open(
  context,
  materialEnabled: false,      // Disable Material tab
  cupertinoEnabled: false,     // Disable Cupertino tab
  colorSchemeEnabled: true,    // Keep Color Scheme tab
  textThemeEnabled: true,      // Keep Text Theme tab
);
```

## API Reference

### ColorSection

Represents a group of related colors.

```dart
ColorSection({
  required String title,
  required List<ColorInfo> colors,
})
```

### ColorInfo

Represents information about a single color.

```dart
ColorInfo({
  required String name,
  required Color color,
  Color? textColor,  // Optional contrast color for text display
})
```

### TextStyleInfo

Represents information about a text style.

```dart
TextStyleInfo(
  String name,
  TextStyle? style,
)
```

### SectionWrapper

A wrapper widget for consistent section formatting.

```dart
SectionWrapper({
  required String title,
  required Widget child,
})
```

### InspectorTab

Represents a custom tab in the inspector.

```dart
InspectorTab({
  required String title,
  required IconData icon,
  required Widget child,
})
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.

