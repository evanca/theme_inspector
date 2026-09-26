import 'package:material_ui/material_ui.dart';

/// Whether a `package:material_ui` [Theme] is present above [context].
///
/// Since 2.0.0 the inspector reads the theme from `package:material_ui`. An app
/// that still uses `package:flutter/material.dart` provides a [Theme] from that
/// library instead, which is a different inherited widget, and provides that
/// library's [MaterialLocalizations] rather than this one's.
///
/// That combination does not merely show the wrong values: building an [AppBar]
/// without matching [MaterialLocalizations] throws. Detecting the situation
/// first lets the inspector explain it instead of failing with an unrelated
/// "No MaterialLocalizations found" error.
bool hasMaterialUiTheme(BuildContext context) =>
    context.findAncestorWidgetOfExactType<Theme>() != null;

/// Explains that the inspector could not find a `package:material_ui` theme.
///
/// Rendered in place of the inspector when no `package:material_ui` [Theme] is
/// an ancestor, which usually means the host app has not migrated off
/// `package:flutter/material.dart`.
///
/// This deliberately avoids [Scaffold], [AppBar] and other widgets that require
/// [MaterialLocalizations], because the absence of those localizations is
/// exactly the situation it reports.
class MissingThemeBanner extends StatelessWidget {
  /// Creates the notice shown when no `package:material_ui` theme was found.
  const MissingThemeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const Color background = Color(0xFFFFE08A);
    const Color foreground = Color(0xFF3E2C00);

    return ColoredBox(
      color: background,
      // Without a Material ancestor the ambient DefaultTextStyle is Flutter's
      // debug one, which underlines every run in yellow. This widget avoids
      // Scaffold and Material deliberately, so it supplies its own base style.
      child: DefaultTextStyle(
        style: const TextStyle(
          color: foreground,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
        child: SafeArea(
          child: Semantics(
            liveRegion: true,
            child: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: foreground,
                    size: 40,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No material_ui theme found',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'theme_inspector 2.x reads the theme from '
                    'package:material_ui, but no material_ui theme was found '
                    'above the inspector. This usually means the app still '
                    'imports package:flutter/material.dart.',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Either migrate the app:',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'dart fix --apply --code=migrate_design_widgets',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'or stay on theme_inspector 1.x, which reads the theme from '
                    'package:flutter/material.dart.',
                    style: TextStyle(
                      color: foreground,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
