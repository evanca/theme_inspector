import 'package:material_ui/material_ui.dart';

import 'section_title.dart';

/// Section wrapper for consistent padding and spacing
class SectionWrapper extends StatelessWidget {
  /// Title displayed above the section content
  final String title;

  /// Widget displayed below the section title
  final Widget child;

  /// Creates a section with a title above the given [child]
  const SectionWrapper({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width > 600 ? 400 : width),
          child: Column(
            children: [
              SectionTitle(title: title),
              const SizedBox(height: 12),
              child,
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
