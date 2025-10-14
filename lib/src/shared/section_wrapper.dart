import 'package:flutter/material.dart';
import 'package:theme_inspector/src/shared/section_title.dart';

/// Section wrapper for consistent padding and spacing
class SectionWrapper extends StatelessWidget {
  final String title;
  final Widget child;

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
