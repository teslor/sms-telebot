import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../constants.dart';
import '../styles.dart';
import '../state.dart';
import '../service.dart';
import '../widgets/action_button.dart';

class RuleFiltersPage extends StatefulWidget {
  const RuleFiltersPage({super.key});

  @override
  State<RuleFiltersPage> createState() => _RuleFiltersPageState();
}

class _RuleFiltersPageState extends State<RuleFiltersPage> {
  final GlobalKey<_ChipsWidgetState> _senderChipsKey = GlobalKey<_ChipsWidgetState>();
  final GlobalKey<_ChipsWidgetState> _bodyChipsKey = GlobalKey<_ChipsWidgetState>();

  int _filterMode = 0;
  Map<String, List<String>> _filterLists = {};

  bool _isInputChanged = false;
  bool? _testResult;
  bool? _saveResult;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();

    _filterMode = appState.filterMode;
    _filterLists = {
      for (final key in AppConst.filterKeys) key: List<String>.from(appState.filterLists[key] ?? const <String>[]),
    };
  }

  void _markInputChanged() {
    setState(() {
      _isInputChanged = true;
      _saveResult = null;
    });
  }

  List<String> _getListNames() {
    return _filterMode == 1 ? AppConst.filterKeys.sublist(0, 2) :
           _filterMode == 2 ? AppConst.filterKeys.sublist(2, 4) : ['', ''];
  }

  void _testFilters() async {
    final sender = _senderChipsKey.currentState?.inputController.text ?? '';
    final body = _bodyChipsKey.currentState?.inputController.text ?? '';
    final result = await checkFiltersNative(sender, body, _filterMode, _filterLists);
    if (!mounted) return;
    setState(() {
      _testResult = result;
    });
  }

  void _saveFilters() async {
    final appState = context.read<AppState>();
    FocusManager.instance.primaryFocus?.unfocus();
    await appState.updateFilters(_filterMode, _filterLists);
    if (mounted) {
      setState(() {
        _saveResult = true;
        _isInputChanged = false;
      });
    }
  } 

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        children:[
          SegmentedButton<int>(
            showSelectedIcon: false,
            style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12))),
            segments: <ButtonSegment<int>>[
              ButtonSegment<int>(value: 0, label: Text(l10n.filters_off, textAlign: TextAlign.center, style: const TextStyle(height: 1.15))),
              ButtonSegment<int>(value: 1, label: Text(l10n.filters_whitelist, textAlign: TextAlign.center, style: const TextStyle(height: 1.15))),
              ButtonSegment<int>(value: 2, label: Text(l10n.filters_blacklist, textAlign: TextAlign.center, style: const TextStyle(height: 1.15))),
            ],
            selected: <int>{_filterMode},
            onSelectionChanged: (Set<int> newSelection) {
              if (_filterMode == newSelection.first) return;
              setState(() {
                _filterMode = newSelection.first;
              });
              _markInputChanged();
            },
          ),
          const SizedBox(height: 16),
          ChipsWidget(
            key: _senderChipsKey,
            listName: _getListNames()[0],
            chips: _filterLists[_getListNames()[0]] ?? const <String>[],
            labelText: l10n.filters_sender,
            helperText: l10n.filters_senderInfo,
            prefixIcon: const Icon(Icons.person_outline_rounded),
            onAddChip: (String chip) {
              final listName = _getListNames()[0];
              if (listName.isEmpty) return;
              setState(() {
                _filterLists[listName]!.add(chip);
              });
              _markInputChanged();
            },
            onDeleteChip: (String chip) {
              final listName = _getListNames()[0];
              if (listName.isEmpty) return;
              setState(() {
                _filterLists[listName]!.remove(chip);
              });
              _markInputChanged();
            },
          ),
          const SizedBox(height: 16),
          ChipsWidget(
            key: _bodyChipsKey,
            listName: _getListNames()[1],
            chips: _filterLists[_getListNames()[1]] ?? const <String>[],
            labelText: l10n.filters_text,
            helperText: l10n.filters_textInfo,
            prefixIcon: const Icon(Icons.sms_outlined),
            onAddChip: (String chip) {
              final listName = _getListNames()[1];
              if (listName.isEmpty) return;
              setState(() {
                _filterLists[listName]!.add(chip);
              });
              _markInputChanged();
            },
            onDeleteChip: (String chip) {
              final listName = _getListNames()[1];
              if (listName.isEmpty) return;
              setState(() {
                _filterLists[listName]!.remove(chip);
              });
              _markInputChanged();
            },
          ),
        ],
      ),

      bottomNavigationBar: Row(
        children:[
          Expanded(
            child: ActionButton(
              label: l10n.action_test,
              onPressed: _filterMode != 0 ? _testFilters : null,
              isSuccess: _testResult,
              layout: 'half-1',
            ),
          ),
          Expanded(
            child: ActionButton(
              label: l10n.action_save,
              onPressed: _isInputChanged ? _saveFilters : null,
              isSuccess: _saveResult,
              layout: 'half-2',
            ),
          )
        ],
      ),
    );
  }
}

class ChipsWidget extends StatefulWidget {
  final String listName; final String labelText; final String helperText; final Widget prefixIcon;
  final List<String> chips;
  final ValueChanged<String> onAddChip;
  final ValueChanged<String> onDeleteChip;

  const ChipsWidget({
    super.key,
    required this.listName,
    required this.labelText,
    required this.helperText,
    required this.prefixIcon,
    required this.chips,
    required this.onAddChip,
    required this.onDeleteChip,
  });

  @override
  State<ChipsWidget> createState() => _ChipsWidgetState();
}

class _ChipsWidgetState extends State<ChipsWidget> {
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: inputController,
          enabled: widget.listName.isNotEmpty,
          decoration: CustomStyle.compactInput(
            labelText: widget.labelText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final text = inputController.text.trim();
                if (text.isEmpty || (isRegex(text) && !await isValidRegexNative(text))) return;
                widget.onAddChip(text);
                inputController.clear();
              },
            ),
          ),
        ),

        Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: -5,
          children: widget.chips.map((chip) {
            return Chip(
              padding: const EdgeInsets.all(5),
              labelStyle: TextStyle(color: isRegex(chip) ? Colors.teal : null),
              label: InkWell(
                onTap: () { inputController.text = chip; },
                child: Text(chip),
              ),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                widget.onDeleteChip(chip);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
