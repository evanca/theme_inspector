import 'package:flutter/material.dart';
import 'package:theme_inspector/src/shared/section_wrapper.dart';

/// A tab that displays various Material widgets for inspection
class MaterialTab extends StatelessWidget {
  const MaterialTab({super.key, this.additionalMaterialWidgets});

  final List<SectionWrapper>? additionalMaterialWidgets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar'),
        leading: Icon(Icons.favorite_outline),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
        ],
        elevation: 1,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Label',
          ),
          const NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'Label',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: 'Label',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Wrap(
            spacing: 32.0,
            runSpacing: 16.0,
            children: [
              if (additionalMaterialWidgets != null)
                ...additionalMaterialWidgets!,

              const SectionWrapper(title: 'Buttons', child: _ButtonsShowcase()),

              const SectionWrapper(
                title: 'Text Fields',
                child: _TextFieldsShowcase(),
              ),

              const SectionWrapper(
                title: 'Controls',
                child: _PickersShowcase(),
              ),

              const SectionWrapper(
                title: 'List Components',
                child: _ListComponentsShowcase(),
              ),

              const SectionWrapper(
                title: 'Selection',
                child: _SelectionControlsShowcase(),
              ),

              const SectionWrapper(title: 'Cards', child: _CardShowcase()),

              const SectionWrapper(
                title: 'Bottom Sheets',
                child: _BottomSheetShowcase(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Base class for all showcase widgets
abstract class _ShowcaseBase extends StatelessWidget {
  const _ShowcaseBase();
}

class _ButtonsShowcase extends _ShowcaseBase {
  const _ButtonsShowcase();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      alignment: WrapAlignment.center,
      children: [
        FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
        FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Extended'),
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
        FilledButton(onPressed: () {}, child: const Text('Filled')),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        TextButton(onPressed: () {}, child: const Text('Text')),
        IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
        IconButton.filled(onPressed: () {}, icon: const Icon(Icons.star)),
        ElevatedButton(onPressed: null, child: const Text('Disabled')),
      ],
    );
  }
}

class _TextFieldsShowcase extends _ShowcaseBase {
  const _TextFieldsShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TextFieldRow(
          left: TextField(
            decoration: const InputDecoration(labelText: 'Basic'),
          ),
          right: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              suffixIcon: Icon(Icons.cancel_outlined),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _TextFieldRow(
          left: TextField(
            decoration: const InputDecoration(
              labelText: 'Disabled',
              border: OutlineInputBorder(),
            ),
            enabled: false,
          ),
          right: TextField(
            decoration: const InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}

class _TextFieldRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const _TextFieldRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }
}

class _SelectionControlsShowcase extends _ShowcaseBase {
  const _SelectionControlsShowcase();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _SwitchesColumn()),
        SizedBox(height: 16),
        Expanded(child: _CheckboxesColumn()),
        SizedBox(height: 16),
        Expanded(child: _RadioButtonsColumn()),
      ],
    );
  }
}

class _SwitchesColumn extends StatefulWidget {
  const _SwitchesColumn();

  @override
  State<_SwitchesColumn> createState() => _SwitchesColumnState();
}

class _SwitchesColumnState extends State<_SwitchesColumn> {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return _ControlColumn(
      children: [
        Switch(
          value: _switchValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
          },
        ),
        Switch(value: false, onChanged: (value) {}),
        const Switch(value: true, onChanged: null),
      ],
    );
  }
}

class _CheckboxesColumn extends StatefulWidget {
  const _CheckboxesColumn();

  @override
  State<_CheckboxesColumn> createState() => _CheckboxesColumnState();
}

class _CheckboxesColumnState extends State<_CheckboxesColumn> {
  bool _checkboxValue = true;

  @override
  Widget build(BuildContext context) {
    return _ControlColumn(
      children: [
        Checkbox(
          value: _checkboxValue,
          onChanged: (value) {
            setState(() {
              _checkboxValue = value ?? false;
            });
          },
        ),
        Checkbox(value: false, onChanged: (value) {}),
        const Checkbox(value: true, onChanged: null),
      ],
    );
  }
}

class _RadioButtonsColumn extends StatefulWidget {
  const _RadioButtonsColumn();

  @override
  State<_RadioButtonsColumn> createState() => _RadioButtonsColumnState();
}

class _RadioButtonsColumnState extends State<_RadioButtonsColumn> {
  int? _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<int>(
      groupValue: _radioValue,
      onChanged: (int? value) {
        setState(() {
          _radioValue = value;
        });
      },
      child: _ControlColumn(
        children: [
          Radio<int>(value: 0),
          Radio<int>(value: 1),
          const Radio<int>(value: 2),
        ],
      ),
    );
  }
}

class _ControlColumn extends StatelessWidget {
  final List<Widget> children;

  const _ControlColumn({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}

class _PickersShowcase extends _ShowcaseBase {
  const _PickersShowcase();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _SegmentedButtonWidget(),
        SizedBox(height: 16),
        _ChoiceChipWidget(),
        SizedBox(height: 16),
        _SliderWidget(),
        SizedBox(height: 16),
        _FilteredChipWidget(),
      ],
    );
  }
}

class _SegmentedButtonWidget extends StatefulWidget {
  const _SegmentedButtonWidget();

  @override
  State<_SegmentedButtonWidget> createState() => _SegmentedButtonWidgetState();
}

class _SegmentedButtonWidgetState extends State<_SegmentedButtonWidget> {
  Set<int> _selectedSegments = {0};

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment<int>(value: 0, label: Text('Option 1')),
        ButtonSegment<int>(value: 1, label: Text('Option 2')),
        ButtonSegment<int>(value: 2, label: Text('Option 3')),
      ],
      selected: _selectedSegments,
      onSelectionChanged: (value) {
        setState(() {
          _selectedSegments = value;
        });
      },
      multiSelectionEnabled: false,
    );
  }
}

class _SliderWidget extends StatefulWidget {
  const _SliderWidget();

  @override
  State<_SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<_SliderWidget> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _sliderValue,
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
            });
          },
        ),
        Text('Slider value: ${(_sliderValue * 100).toStringAsFixed(0)}%'),
      ],
    );
  }
}

class _ListComponentsShowcase extends _ShowcaseBase {
  const _ListComponentsShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Title'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Title'),
          subtitle: const Text('Subtitle'),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info_outline),
          ),
          onTap: () {},
        ),
        const Divider(height: 1),
        const ListTile(title: Text('Disabled'), enabled: false),
      ],
    );
  }
}

class _FilteredChipWidget extends StatefulWidget {
  const _FilteredChipWidget();

  @override
  State<_FilteredChipWidget> createState() => _FilteredChipWidgetState();
}

class _FilteredChipWidgetState extends State<_FilteredChipWidget> {
  final Set<String> _selectedChips = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        FilterChip(
          avatar: CircleAvatar(),
          label: const Text('Filter 1'),
          selected: _selectedChips.contains('Filter 1'),
          onSelected: (value) {
            setState(() {
              if (value) {
                _selectedChips.add('Filter 1');
              } else {
                _selectedChips.remove('Filter 1');
              }
            });
          },
        ),
        FilterChip(
          label: const Text('Filter 2'),
          selected: _selectedChips.contains('Filter 2'),
          onSelected: (value) {
            setState(() {
              if (value) {
                _selectedChips.add('Filter 2');
              } else {
                _selectedChips.remove('Filter 2');
              }
            });
          },
          onDeleted: () {},
          deleteIcon: const Icon(Icons.close),
        ),
        FilterChip(
          label: const Text('Filter 3'),
          selected: _selectedChips.contains('Filter 3'),
          onSelected: (value) {
            setState(() {
              if (value) {
                _selectedChips.add('Filter 3');
              } else {
                _selectedChips.remove('Filter 3');
              }
            });
          },
        ),
      ],
    );
  }
}

class _ChoiceChipWidget extends StatefulWidget {
  const _ChoiceChipWidget();

  @override
  State<_ChoiceChipWidget> createState() => _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<_ChoiceChipWidget> {
  String? _selectedChip;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        ChoiceChip(
          avatar: CircleAvatar(),
          label: const Text('Choice 1'),
          selected: _selectedChip == 'Choice 1',
          onSelected: (value) {
            setState(() {
              _selectedChip = value ? 'Choice 1' : null;
            });
          },
        ),
        ChoiceChip(
          label: const Text('Choice 2'),
          selected: _selectedChip == 'Choice 2',
          onSelected: (value) {
            setState(() {
              _selectedChip = value ? 'Choice 2' : null;
            });
          },
        ),
      ],
    );
  }
}

class _CardShowcase extends _ShowcaseBase {
  const _CardShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 100,
            width: 150,
            child: Text('Card'),
          ),
        ),
      ],
    );
  }
}

class _BottomSheetShowcase extends _ShowcaseBase {
  const _BottomSheetShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  width: 300,
                  height: 300,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Modal Bottom Sheet'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Text('Show Modal Bottom Sheet'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Scaffold.of(context).showBottomSheet((context) {
              return Container(
                width: 300,
                height: 300,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Persistent Bottom Sheet'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            });
          },
          child: const Text('Show Persistent Bottom Sheet'),
        ),
      ],
    );
  }
}
