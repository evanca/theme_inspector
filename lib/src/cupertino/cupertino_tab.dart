import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_inspector/src/color_scheme/color_info.dart';
import 'package:theme_inspector/src/color_scheme/color_scheme_tab.dart';
import 'package:theme_inspector/src/shared/section_wrapper.dart';

/// A tab that displays various Cupertino widgets for inspection
class CupertinoTab extends StatelessWidget {
  const CupertinoTab({super.key, this.additionalCupertinoWidgets});

  final List<Widget>? additionalCupertinoWidgets;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        middle: const Text('CupertinoNavigationBar'),
        trailing: Icon(CupertinoIcons.ellipsis),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 100, 24, 40),
                child: Wrap(
                  spacing: 32.0,
                  runSpacing: 16.0,
                  children: [
                    if (additionalCupertinoWidgets != null)
                      ...additionalCupertinoWidgets!,

                    const SectionWrapper(
                      title: 'Buttons',
                      child: _ButtonsShowcase(),
                    ),

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
                      title: 'Cupertino Form',
                      child: _FormComponentsShowcase(),
                    ),

                    const SectionWrapper(
                      title: 'Selection',
                      child: _SelectionControlsShowcase(),
                    ),

                    const SectionWrapper(
                      title: 'Color Constants',
                      child: _CupertinoColorsShowcase(),
                    ),

                    const SectionWrapper(
                      title: 'Bottom Sheets',
                      child: _BottomSheetShowcase(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CupertinoTabBar(
            height: 60,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'Label',
              ),
              const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.plus_app),
                label: 'Label',
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.gear),
                label: 'Label',
              ),
            ],
          ),
        ],
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
        CupertinoButton(onPressed: () {}, child: const Text('Button')),
        CupertinoButton.filled(onPressed: () {}, child: const Text('Filled')),
        CupertinoButton(onPressed: null, child: const Text('Disabled')),
        CupertinoButton.tinted(onPressed: () {}, child: const Text('Tinted')),
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
          left: CupertinoTextField(placeholder: 'Basic'),
          right: CupertinoTextField(
            prefix: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(CupertinoIcons.person),
            ),
            suffix: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(CupertinoIcons.clear_circled),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _TextFieldRow(
          left: CupertinoTextField(placeholder: 'Disabled', readOnly: true),
          right: CupertinoSearchTextField(
            placeholder: 'Search',
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
        CupertinoSwitch(
          value: _switchValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
          },
        ),
        CupertinoSwitch(value: false, onChanged: (value) {}),
        const CupertinoSwitch(value: true, onChanged: null),
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
        CupertinoCheckbox(
          value: _checkboxValue,
          onChanged: (value) {
            setState(() {
              _checkboxValue = value ?? false;
            });
          },
        ),
        CupertinoCheckbox(value: false, onChanged: (value) {}),
        const CupertinoCheckbox(value: true, onChanged: null),
      ],
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
        _SegmentedControlWidget(),
        SizedBox(height: 16),
        _SliderWidget(),
        SizedBox(height: 16),
      ],
    );
  }
}

class _SegmentedControlWidget extends StatefulWidget {
  const _SegmentedControlWidget();

  @override
  State<_SegmentedControlWidget> createState() =>
      _SegmentedControlWidgetState();
}

class _SegmentedControlWidgetState extends State<_SegmentedControlWidget> {
  int _segmentedControlValue = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<int>(
      groupValue: _segmentedControlValue,
      children: const {
        0: Text('Option 1'),
        1: Text('Option 2'),
        2: Text('Option 3'),
      },
      onValueChanged: (value) {
        setState(() {
          _segmentedControlValue = value ?? 0;
        });
      },
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
        CupertinoSlider(
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
        CupertinoListTile(
          title: const Text('Title'),
          trailing: const CupertinoListTileChevron(),
          additionalInfo: const Text('Additional Info'),
          onTap: () {},
        ),
        Divider(height: 16),
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.person),
          title: const Text('Title'),
          subtitle: const Text('Subtitle'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(CupertinoIcons.info),
          ),
          onTap: () {},
        ),
        Divider(height: 16),
        CupertinoListTile(title: const Text('Disabled'), onTap: null),
      ],
    );
  }
}

class _FormComponentsShowcase extends _ShowcaseBase {
  const _FormComponentsShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoFormSection(
          header: const Text('Form Section'),
          children: [
            CupertinoTextFormFieldRow(
              prefix: const Text('Prefix'),
              placeholder: 'CupertinoTextFormFieldRow',
              controller: TextEditingController(),
              onChanged: (value) {},
            ),
            CupertinoFormRow(
              prefix: const Text('Prefix'),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: CupertinoTextField(placeholder: 'CupertinoFormRow'),
              ),
              helper: const Text('Helper'),
              error: const Text('Error'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CupertinoColorsShowcase extends _ShowcaseBase {
  const _CupertinoColorsShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColorCard(
          colorInfo: ColorInfo(
            name: 'systemBackground',
            color: CupertinoColors.systemBackground.resolveFrom(context),
            textColor: CupertinoColors.label.resolveFrom(context),
          ),
        ),
        ColorCard(
          colorInfo: ColorInfo(
            name: 'secondarySystemBackground',
            color: CupertinoColors.secondarySystemBackground.resolveFrom(
              context,
            ),
            textColor: CupertinoColors.label.resolveFrom(context),
          ),
        ),
        ColorCard(
          colorInfo: ColorInfo(
            name: 'inactiveGray',
            color: CupertinoColors.inactiveGray.resolveFrom(context),
            textColor: CupertinoColors.white,
          ),
        ),
        ColorCard(
          colorInfo: ColorInfo(
            name: 'activeBlue',
            color: CupertinoColors.activeBlue.resolveFrom(context),
            textColor: CupertinoColors.white,
          ),
        ),
        ColorCard(
          colorInfo: ColorInfo(
            name: 'destructiveRed',
            color: CupertinoColors.destructiveRed.resolveFrom(context),
            textColor: CupertinoColors.white,
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
        CupertinoButton.tinted(
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder:
                  (context) => CupertinoActionSheet(
                    title: const Text('Action Sheet Title'),
                    message: const Text(
                      'This is the message of the action sheet',
                    ),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Action 1'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Action 2'),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(context),
                      isDefaultAction: true,
                      child: const Text('Cancel'),
                    ),
                  ),
            );
          },
          child: const Text('Show Action Sheet'),
        ),
        const SizedBox(height: 16),
        CupertinoButton.tinted(
          onPressed: () {
            showCupertinoSheet(
              context: context,
              pageBuilder:
                  (context) => CupertinoPageScaffold(
                    child: Center(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.label.resolveFrom(context),
                        ),
                        child: Text(
                          'This is a Cupertino bottom sheet',
                          style: TextStyle(
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                      ),
                    ),
                  ),
            );
          },
          child: const Text('Show Bottom Sheet'),
        ),
      ],
    );
  }
}
