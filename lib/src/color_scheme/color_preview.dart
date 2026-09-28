import 'package:material_ui/material_ui.dart';

import 'color_usages.dart';

/// Real Material widgets drawn with the ambient theme.
///
/// Every widget here keeps its default colours, so what it paints is what
/// [kColorUsages] says it reads.
class ColorPreview extends StatelessWidget {
  /// Creates the preview.
  const ColorPreview({super.key});

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
            leading: const Icon(Icons.menu),
            title: const Text('AppBar'),
          ),
        ),
        const Card(
          margin: EdgeInsets.zero,
          child: Padding(padding: EdgeInsets.all(16), child: Text('Card')),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(onPressed: () {}, child: const Text('Filled')),
            FilledButton.tonal(onPressed: () {}, child: const Text('Tonal')),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
          ],
        ),
        const Row(
          spacing: 8,
          children: [
            Expanded(
              child: InputDecorator(
                isFocused: true,
                decoration: InputDecoration(
                  labelText: 'Focused',
                  border: OutlineInputBorder(),
                ),
                child: Text('Text'),
              ),
            ),
            Expanded(
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Invalid',
                  errorText: 'errorText',
                  border: OutlineInputBorder(),
                ),
                child: Text('Text'),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Switch(value: true, onChanged: (_) {}),
            FilterChip(
              label: const Text('FilterChip'),
              selected: true,
              onSelected: (_) {},
            ),
            FloatingActionButton(
              heroTag: null,
              tooltip: 'FloatingActionButton',
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
