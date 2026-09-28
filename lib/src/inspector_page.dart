import 'package:material_ui/material_ui.dart';
import 'package:theme_inspector/theme_inspector.dart';

import 'inspector_layouts.dart';
import 'shared/missing_theme_banner.dart';

/// This widget displays a navigable interface showing different aspects of the current theme,
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
  final List<SectionWrapper>? additionalMaterialWidgets;

  /// Additional Cupertino widgets to display in the Cupertino tab.
  ///
  /// These widgets will be shown after the default Cupertino widget examples.
  final List<SectionWrapper>? additionalCupertinoWidgets;

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
    _tabController.addListener(_onTabChanged);
  }

  /// Rebuilds when the selected tab settles, so the navigation and the shown
  /// tab follow selections made by swiping as well as by tapping.
  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  /// Selects a tab from the rail or bottom bar. A zero duration settles the
  /// index at once, so the listener rebuilds without waiting for an animation
  /// that only [CompactTabLayout]'s TabBarView would show.
  void _onSelected(int index) =>
      _tabController.animateTo(index, duration: Duration.zero);

  @override
  Widget build(BuildContext context) {
    // Bail out before building any widget that needs this library's
    // MaterialLocalizations, which a non-migrated host app does not provide.
    if (!hasMaterialUiTheme(context)) {
      return const MissingThemeBanner();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final int index = _tabController.index;
        // Both navigation widgets need at least two destinations.
        if (_tabs.length < 2) return SingleTabLayout(tabs: _tabs);
        if (constraints.maxWidth >= kRailBreakpoint) {
          return RailLayout(tabs: _tabs, index: index, onSelected: _onSelected);
        }
        if (_tabs.length <= kMaxBottomBarDestinations) {
          return BottomBarLayout(
            tabs: _tabs,
            index: index,
            onSelected: _onSelected,
          );
        }
        return CompactTabLayout(tabs: _tabs, controller: _tabController);
      },
    );
  }
}
