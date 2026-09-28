import 'package:material_ui/material_ui.dart';

/// Content width from which a tab shows "where used" as a side panel beside
/// its list. Below it, selecting an item opens the panel as a bottom sheet.
const double kWhereUsedPanelMinWidth = 760.0;

/// Width of the "where used" side panel.
const double kWhereUsedPanelWidth = 400.0;

/// One widget property that reads a theme value by default.
class WidgetUsage {
  /// Creates a usage of a theme value by [widget]'s [property].
  const WidgetUsage(this.widget, this.property, {this.role});

  /// Widget class name, e.g. `FilledButton`.
  final String widget;

  /// Property that takes the value, e.g. `backgroundColor`.
  final String property;

  /// Colour role the property reads, when the panel covers a pair of roles.
  final String? role;
}

/// Opens [builder]'s panel as a draggable bottom sheet.
Future<void> showWhereUsedSheet(
  BuildContext context,
  Widget Function(ScrollController controller) builder,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, controller) => builder(controller),
    ),
  );
}

/// Frames a [WhereUsedPanel] as a side panel beside a tab's list.
class WhereUsedSidePanel extends StatelessWidget {
  /// Creates the side-panel frame around [child].
  const WhereUsedSidePanel({super.key, required this.child});

  /// The panel, usually a [WhereUsedPanel].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
      child: SizedBox(
        width: kWhereUsedPanelWidth,
        child: Material(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}

/// Shows which widgets use the selected theme value: the list of [usages],
/// after a live [preview] of those widgets drawn with the ambient theme.
class WhereUsedPanel extends StatelessWidget {
  /// Creates the panel for the value named [title].
  const WhereUsedPanel({
    super.key,
    required this.title,
    required this.preview,
    required this.usages,
    required this.emptyMessage,
    this.leading,
    this.subtitle,
    this.trailing,
    this.controller,
  });

  /// Name of the selected colour role or text style.
  final String title;

  /// Shown before the title, e.g. a colour swatch.
  final Widget? leading;

  /// Shown under the title, e.g. text style metrics.
  final String? subtitle;

  /// Shown after the title, e.g. a copy button.
  final Widget? trailing;

  /// Real widgets rendered with the ambient theme.
  final Widget preview;

  /// Widget properties that read the value by default.
  final List<WidgetUsage> usages;

  /// Shown instead of the list when [usages] is empty.
  final String emptyMessage;

  /// Scroll controller, supplied when the panel is inside a bottom sheet.
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final TextTheme text = theme.textTheme;

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      children: [
        Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHERE USED',
                    style: text.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(title, style: text.titleLarge),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: text.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 16),
        Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),
          clipBehavior: Clip.antiAlias,
          child: Padding(padding: const EdgeInsets.all(12), child: preview),
        ),
        const SizedBox(height: 16),
        if (usages.isEmpty)
          _PanelNote(emptyMessage)
        else
          for (final WidgetUsage usage in usages) _UsageRow(usage),
      ],
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow(this.usage);

  final WidgetUsage usage;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final String role = usage.role == null ? '' : ': ${usage.role}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(usage.widget, style: text.titleSmall),
              Text(
                '${usage.property}$role',
                style: text.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelNote extends StatelessWidget {
  const _PanelNote(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ),
    );
  }
}
