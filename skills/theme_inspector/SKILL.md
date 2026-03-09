---
name: theme_inspector
description: Use when building a new Flutter app, when changing themes/colors/fonts, or when adding custom widgets.
---

# Theme Inspector

A Flutter package that provides an interactive inspector for visualizing and debugging your app's themes, including Material and Cupertino widgets, color schemes, and text styles.

## When to Use

- When building a new app — open the inspector to show out-of-the-box Material and Cupertino widgets to the customer with the current theme applied.
- When changing the app theme, fonts, or colors — open the inspector to see how changes impacted the UI across all widget types.
- When adding a new custom widget — add it to the inspector to keep the widget catalogue in one place. Prefer creating a custom tab via `customTabs` with `InspectorTab`; alternatively, append to existing tabs via `additionalMaterialWidgets` or `additionalCupertinoWidgets`.

## Instructions

### Quick Start

Import the package and open the inspector:

```dart
import 'package:theme_inspector/theme_inspector.dart';

ThemeInspector.open(context);
```

This opens a page with four default tabs:

- **Color Scheme** — all `ColorScheme` colors with copy-to-clipboard functionality.
- **Material** — Material widgets (buttons, text fields, cards, etc.).
- **Cupertino** — iOS-style Cupertino widgets.
- **Text Theme** — all `TextTheme` styles with size information.

### Adding Custom Colors

Display a custom color palette alongside the default `ColorScheme`:

```dart
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

Show custom typography alongside the default `TextTheme`:

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

### Adding Custom Widgets to Material or Cupertino Tab

Display custom widgets to see how they look with the current theme:

```dart
ThemeInspector.open(
  context,
  additionalMaterialWidgets: [
    SectionWrapper(
      title: 'My Custom Widget',
      child: myCustomWidget,
    ),
  ],
  additionalCupertinoWidgets: [
    SectionWrapper(
      title: 'My Custom Cupertino Widget',
      child: myCustomCupertinoWidget,
    ),
  ],
);
```

### Creating Custom Tabs

Add completely custom tabs with your own content:

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
          'Custom tab content here.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ),
  ],
);
```

### Disabling Default Tabs

Disable any of the built-in tabs:

```dart
ThemeInspector.open(
  context,
  materialEnabled: false,
  cupertinoEnabled: false,
  colorSchemeEnabled: true,
  textThemeEnabled: true,
);
```

### API Reference

- `ColorSection({required String title, required List<ColorInfo> colors})` — a group of related colors.
- `ColorInfo({required String name, required Color color, Color? textColor})` — information about a single color.
- `TextStyleInfo(String name, TextStyle? style)` — information about a text style.
- `SectionWrapper({required String title, required Widget child})` — a wrapper widget for consistent section formatting.
- `InspectorTab({required String title, required IconData icon, required Widget child})` — a custom tab in the inspector.

## Best Practices

- Activate the inspector in debug mode only — for example, by tapping several times on the app version number, so it 
  is not accessible in production.
- When adding a new custom widget, always add it to the inspector's custom widgets tab to keep the widget catalogue comprehensive and up to date.
- Inform user on how to use the tool.
