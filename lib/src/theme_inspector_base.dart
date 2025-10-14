import 'package:flutter/material.dart';
import 'package:theme_inspector/src/shared/section_wrapper.dart';
import 'package:theme_inspector/src/text_theme/text_style_info.dart';
import 'package:theme_inspector/src/text_theme/text_theme_tab.dart';

import 'color_scheme/color_scheme_tab.dart';
import 'color_scheme/color_section.dart';
import 'cupertino/cupertino_tab.dart';
import 'inspector_page.dart';
import 'material/material_tab.dart';

/// A utility for inspecting and visualizing theme configurations in Flutter applications.
///
/// The theme inspector provides a visual interface to explore your app's current theme,
/// including Material and Cupertino widgets, color schemes, and text styles. This tool
/// is particularly useful during development to:
///
/// * Debug theme inconsistencies
/// * Visualize how theme changes affect your UI components
/// * Document theme specifications for design handoffs
/// * Explore the relationships between different theme components
///
/// Use the static [open] method to launch the inspector from anywhere in your app:
///
/// ```dart
/// FloatingActionButton(
///   onPressed: () => ThemeInspector.open(context),
///   child: Icon(Icons.palette),
/// )
/// ```
class ThemeInspector {
  /// Opens the theme inspector page with the specified configuration.
  ///
  /// The inspector displays your app's current theme in a modal page with tabs
  /// for exploring different aspects of the theme.
  ///
  /// Parameters:
  /// * [additionalColors] - Custom ColorSections to display in the Color
  /// Scheme tab.
  /// * [additionalTextStyles] - Custom TextStyleInfos to display in the Text
  /// Theme tab.
  /// * [context] - The build context used to access the current theme and navigator.
  /// * [additionalMaterialWidgets] - Custom SectionWrappers for Material
  /// widgets to display alongside the defaults.
  /// * [additionalCupertinoWidgets] - Custom SectionWrappers for Cupertino
  /// widgets to display alongside the defaults.
  /// * [customTabs] - Multiple custom tabs to add to the inspector.
  /// * [materialEnabled] - Whether to include the Material tab (default: true).
  /// * [cupertinoEnabled] - Whether to include the Cupertino tab (default: true).
  /// * [colorSchemeEnabled] - Whether to include the Color Scheme tab (default: true).
  /// * [textThemeEnabled] - Whether to include the Text Theme tab (default: true).
  static void open(
    BuildContext context, {
    List<ColorSection>? additionalColors,
    List<TextStyleInfo>? additionalTextStyles,
    List<SectionWrapper>? additionalMaterialWidgets,
    List<SectionWrapper>? additionalCupertinoWidgets,
    List<InspectorTab>? customTabs,
    bool materialEnabled = true,
    bool cupertinoEnabled = true,
    bool colorSchemeEnabled = true,
    bool textThemeEnabled = true,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => InspectorPage(
              additionalColors: additionalColors,
              additionalTextStyles: additionalTextStyles,
              additionalMaterialWidgets: additionalMaterialWidgets,
              additionalCupertinoWidgets: additionalCupertinoWidgets,
              customTabs: customTabs,
              materialEnabled: materialEnabled,
              cupertinoEnabled: cupertinoEnabled,
              colorSchemeEnabled: colorSchemeEnabled,
              textThemeEnabled: textThemeEnabled,
            ),
      ),
    );
  }
}

/// A custom tab for the inspector
class InspectorTab {
  /// Title of the tab
  final String title;

  /// Icon for the tab
  final IconData icon;

  /// Widget to display in the tab
  final Widget child;

  /// Creates a custom tab for the inspector
  const InspectorTab({
    required this.title,
    required this.icon,
    required this.child,
  });

  /// Color scheme tab
  factory InspectorTab.colorScheme(additionalColors) {
    return InspectorTab(
      title: 'Color Scheme',
      icon: Icons.color_lens,
      child: ColorSchemeTab(additionalColors: additionalColors),
    );
  }

  /// Material theme components tab
  factory InspectorTab.material(additionalMaterialWidgets) {
    return InspectorTab(
      title: 'Material',
      icon: Icons.android,
      child: MaterialTab(additionalMaterialWidgets: additionalMaterialWidgets),
    );
  }

  /// Cupertino theme components tab
  factory InspectorTab.cupertino(additionalCupertinoWidgets) {
    return InspectorTab(
      title: 'Cupertino',
      icon: Icons.apple,
      child: CupertinoTab(
        additionalCupertinoWidgets: additionalCupertinoWidgets,
      ),
    );
  }

  /// Text theme tab
  factory InspectorTab.textTheme(additionalTextStyles) {
    return InspectorTab(
      title: 'Text Theme',
      icon: Icons.text_fields,
      child: TextThemeTab(additionalTextStyles: additionalTextStyles),
    );
  }
}
