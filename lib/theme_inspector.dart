/// An interactive inspector for visualizing and debugging a Flutter app's
/// theme.
///
/// The inspector renders Material and Cupertino widgets, the active
/// `ColorScheme` and the active `TextTheme` with the ambient theme applied, so
/// you can see how theme changes affect your UI in one place.
///
/// Open it from anywhere in your app with [ThemeInspector.open]:
///
/// ```dart
/// import 'package:theme_inspector/theme_inspector.dart';
///
/// ThemeInspector.open(context);
/// ```
///
/// Each built-in tab can be disabled, and the inspector can be extended with
/// your own colors ([ColorSection], [ColorInfo]), text styles
/// ([TextStyleInfo]), widgets ([SectionWrapper]) and whole tabs
/// ([InspectorTab]).
library;

export 'src/color_scheme/color_info.dart';
export 'src/color_scheme/color_section.dart';
export 'src/shared/section_wrapper.dart';
export 'src/text_theme/text_style_info.dart';
export 'src/theme_inspector_base.dart';
