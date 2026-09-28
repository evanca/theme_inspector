import 'package:material_ui/material_ui.dart';

import 'text_style_usages.dart';

/// Real Material widgets drawn with the ambient text theme.
///
/// Every widget here keeps its default text styles, so what it paints is what
/// [kTextStyleUsages] says it reads.
class TextStylePreview extends StatelessWidget {
  /// Creates the preview.
  const TextStylePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        SizedBox(
          height: kToolbarHeight,
          child: AppBar(
            primary: false,
            automaticallyImplyLeading: false,
            title: const Text('AppBar title'),
          ),
        ),
        const DefaultTabController(
          length: 2,
          child: TabBar(
            tabs: [
              Tab(text: 'Tab'),
              Tab(text: 'Tab'),
            ],
          ),
        ),
        const ListTile(
          title: Text('ListTile title'),
          subtitle: Text('Subtitle'),
          trailing: Text('12:00'),
        ),
        TextFormField(
          initialValue: 'Input text',
          decoration: const InputDecoration(
            labelText: 'Label',
            helperText: 'Helper text',
            border: OutlineInputBorder(),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton(onPressed: () {}, child: const Text('Button')),
            FilterChip(
              label: const Text('Chip'),
              selected: false,
              onSelected: (_) {},
            ),
          ],
        ),
        const Text('Text with no style inherits the Material default.'),
        const AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: Text('Dialog title'),
          content: Text('Dialog content text.'),
        ),
      ],
    );
  }
}
