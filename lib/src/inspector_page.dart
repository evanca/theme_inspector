import 'package:flutter/material.dart';
import 'package:theme_inspector/src/color_scheme/color_section.dart';
import 'package:theme_inspector/src/text_theme/text_style_info.dart';
import 'package:theme_inspector/src/theme_inspector_base.dart';

/// This widget displays a tabbed interface showing different aspects of the current theme,
/// including Material widgets, Cupertino widgets, color schemes, and text styles.
/// It can be customized with additional widgets, colors, and styles, and can display
/// completely custom tabs.
///
/// This widget is usually not instantiated directly but is instead created by
/// [ThemeInspector.open].
class InspectorPage extends StatefulWidget {
  /// Additional color sections to display in the Color Scheme tab.
  ///
  /// These sections will be shown after the default color scheme sections.
  final List<ColorSection>? additionalColors;

  /// Additional text styles to display in the Text Theme tab.
  ///
  /// These styles will be shown after the default text theme styles.
  final List<TextStyleInfo>? additionalTextStyles;

  /// Additional Material widgets to display in the Material tab.
  ///
  /// These widgets will be shown after the default Material widget examples.
  final List<Widget>? additionalMaterialWidgets;

  /// Additional Cupertino widgets to display in the Cupertino tab.
  ///
  /// These widgets will be shown after the default Cupertino widget examples.
  final List<Widget>? additionalCupertinoWidgets;

  /// Custom tabs to add to the inspector.
  ///
  /// These tabs will be displayed after the default tabs and can contain any widget.
  final List<InspectorTab>? customTabs;

  /// Whether the color scheme tab is enabled.
  final bool colorSchemeEnabled;

  /// Whether the Material tab is enabled.
  final bool materialEnabled;

  /// Whether the Cupertino tab is enabled.
  final bool cupertinoEnabled;

  /// Whether the text theme tab is enabled.
  final bool textThemeEnabled;

  /// Creates a new Theme Inspector page.
  ///
  /// All parameters are optional. When not provided, the inspector will display
  /// only the default content for each tab.
  const InspectorPage({
    super.key,
    this.additionalColors,
    this.additionalTextStyles,
    this.additionalMaterialWidgets,
    this.additionalCupertinoWidgets,
    this.customTabs,
    this.colorSchemeEnabled = true,
    this.materialEnabled = true,
    this.cupertinoEnabled = true,
    this.textThemeEnabled = true,
  });

  @override
  State<InspectorPage> createState() => _InspectorPageState();
}

/// The state for [InspectorPage].
///
/// Manages the tabs and tab controller for the inspector UI.
class _InspectorPageState extends State<InspectorPage>
    with SingleTickerProviderStateMixin {
  /// The complete list of tabs to display in the inspector.
  ///
  /// This includes both default tabs and any custom tabs provided.
  late List<InspectorTab> _tabs;

  /// The controller for the tab view.
  ///
  /// Manages the current tab selection and animations between tabs.
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    List<InspectorTab> defaultTabs = [
      if (widget.colorSchemeEnabled)
        InspectorTab.colorScheme(widget.additionalColors),
      if (widget.materialEnabled)
        InspectorTab.material(widget.additionalMaterialWidgets),
      if (widget.cupertinoEnabled)
        InspectorTab.cupertino(widget.additionalCupertinoWidgets),
      if (widget.textThemeEnabled)
        InspectorTab.textTheme(widget.additionalTextStyles),
      if (widget.customTabs != null) ...widget.customTabs!,
    ];

    _tabs = defaultTabs;
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 600;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: BackButton(),
            title: TabBar(
              controller: _tabController,
              isScrollable: isSmallScreen,
              tabs: List.generate(
                _tabs.length,
                (index) => Tab(
                  text: isSmallScreen ? null : _tabs[index].title,
                  icon: Icon(_tabs[index].icon),
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: List.generate(
              _tabs.length,
              (index) => _tabs[index].child,
            ),
          ),
        );
      },
    );
  }
}
