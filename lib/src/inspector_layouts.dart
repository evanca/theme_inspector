import 'package:material_ui/material_ui.dart';

import 'theme_inspector_base.dart';

/// Width from which the inspector uses a navigation rail instead of a bottom
/// navigation bar: the Material 3 boundary between compact and medium windows.
const double kRailBreakpoint = 600.0;

/// Most destinations a bottom navigation bar holds. With more tabs, a narrow
/// screen falls back to [CompactTabLayout].
const int kMaxBottomBarDestinations = 5;

/// Signature shared by the three layouts' tab selection callbacks.
typedef TabSelected = void Function(int index);

/// Wide layout: a navigation rail beside the selected tab, titled.
class RailLayout extends StatelessWidget {
  /// Creates the rail layout showing [tabs] at [index].
  const RailLayout({
    super.key,
    required this.tabs,
    required this.index,
    required this.onSelected,
  });

  final List<InspectorTab> tabs;
  final int index;
  final TabSelected onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final InspectorTab tab = tabs[index];

    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scrolls only when there are more tabs than the window is tall.
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      backgroundColor: theme.colorScheme.surfaceContainer,
                      labelType: NavigationRailLabelType.all,
                      leading: const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: BackButton(),
                      ),
                      selectedIndex: index,
                      onDestinationSelected: onSelected,
                      destinations: [
                        for (final InspectorTab t in tabs)
                          NavigationRailDestination(
                            icon: Icon(t.icon),
                            label: Text(t.navigationLabel),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 24, 32, 4),
                    child: Semantics(
                      header: true,
                      child: Text(
                        tab.title,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Expanded(
                    child: KeyedSubtree(key: ValueKey(index), child: tab.child),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Phone layout: an app bar titled with the selected tab, and a bottom
/// navigation bar.
class BottomBarLayout extends StatelessWidget {
  /// Creates the bottom bar layout showing [tabs] at [index].
  const BottomBarLayout({
    super.key,
    required this.tabs,
    required this.index,
    required this.onSelected,
  });

  final List<InspectorTab> tabs;
  final int index;
  final TabSelected onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(tabs[index].title),
      ),
      body: KeyedSubtree(key: ValueKey(index), child: tabs[index].child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: onSelected,
        destinations: [
          for (final InspectorTab t in tabs)
            NavigationDestination(icon: Icon(t.icon), label: t.navigationLabel),
        ],
      ),
    );
  }
}

/// Phone layout for more tabs than a bottom navigation bar holds: a
/// scrollable row of icons in the app bar, showing only the selected tab's
/// label.
class CompactTabLayout extends StatelessWidget {
  /// Creates the compact tab layout driven by [controller].
  const CompactTabLayout({
    super.key,
    required this.tabs,
    required this.controller,
  });

  final List<InspectorTab> tabs;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
        title: TabBar(
          controller: controller,
          isScrollable: true,
          tabs: [
            for (int i = 0; i < tabs.length; i++)
              Tab(
                height: kMinInteractiveDimension,
                child: Semantics(
                  // The label of an unselected tab is faded out, and
                  // RenderOpacity drops its subtree from the semantics tree at
                  // zero opacity. Without this, screen readers announce every
                  // unselected tab as unlabelled.
                  label: tabs[i].title,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tabs[i].icon),
                      Opacity(
                        key: ValueKey('tab_label_opacity_$i'),
                        opacity: i == controller.index ? 1.0 : 0.0,
                        child: ExcludeSemantics(
                          child: Text(tabs[i].navigationLabel),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [for (final InspectorTab t in tabs) t.child],
      ),
    );
  }
}

/// Layout for zero or one tab, where there is nothing to navigate between.
class SingleTabLayout extends StatelessWidget {
  /// Creates the layout for [tabs], which holds at most one tab.
  const SingleTabLayout({super.key, required this.tabs});

  final List<InspectorTab> tabs;

  @override
  Widget build(BuildContext context) {
    final InspectorTab? tab = tabs.firstOrNull;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: tab == null ? null : Text(tab.title),
      ),
      body: tab?.child,
    );
  }
}
