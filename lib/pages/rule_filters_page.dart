import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../constants.dart';
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
  final GlobalKey<_ChipsWidgetState> _smsChipsKey = GlobalKey<_ChipsWidgetState>();
  bool? _testResult;
  bool? _saveResult;

  List<String> _getListNames() {
    final appState = context.read<AppState>();
    return appState.filterMode == 1 ? AppConst.filterKeys.sublist(0, 2) :
           appState.filterMode == 2 ? AppConst.filterKeys.sublist(2, 4) : ['', ''];
  }

  void _testFilters() async {
    final appState = context.read<AppState>();
    final sender = _senderChipsKey.currentState?.inputController.text ?? '';
    final sms = _smsChipsKey.currentState?.inputController.text ?? '';
    final result = await checkFiltersNative(sender, sms, appState.filterMode, appState.filterLists);
    if (!mounted) return;
    setState(() {
      _testResult = result;
    });
  }

  void _saveFilters() async {
    final appState = context.read<AppState>();
    FocusManager.instance.primaryFocus?.unfocus();
    await appState.saveFilters();
    if (mounted) {
      setState(() { _saveResult = true; });
    }
  } 

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children:[
          SegmentedButton<int>(
            showSelectedIcon: false,
            style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12))),
            segments: <ButtonSegment<int>>[
              ButtonSegment<int>(value: 0, label: Text(l10n.filters_off, textAlign: TextAlign.center, style: const TextStyle(height: 1.15))),
              ButtonSegment<int>(value: 1, label: Text(l10n.filters_whitelist, textAlign: TextAlign.center, style: const TextStyle(height: 1.15))),
              ButtonSegment<int>(value: 2, label: Text(l10n.filters_blacklist, textAlign: TextAlign.center, style: const TextStyle(height: 1.15))),
            ],
            selected: <int>{appState.filterMode},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() { _saveResult = null; });
              appState.setFilterMode(newSelection.first);
            },
          ),
          const SizedBox(height: 20),
          ChipsWidget(
            key: _senderChipsKey,
            listName: _getListNames()[0],
            labelText: l10n.filters_sender,
            helperText: l10n.filters_senderInfo,
            prefixIcon: const Icon(Icons.person_outline_rounded)
          ),
          const SizedBox(height: 20),
          ChipsWidget(
            key: _smsChipsKey,
            listName: _getListNames()[1],
            labelText: l10n.filters_text,
            helperText: l10n.filters_textInfo,
            prefixIcon: const Icon(Icons.sms_outlined)
          ),
        ],
      ),

      bottomNavigationBar: Row(
        children:[
          Expanded(
            child: ActionButton(
              label: l10n.action_test,
              onPressed: _testFilters,
              isSuccess: _testResult,
              layout: 'half-1',
            ),
          ),
          Expanded(
            child: ActionButton(
              label: l10n.action_save,
              onPressed: _saveFilters,
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

  const ChipsWidget({
    super.key, required this.listName, required this.labelText, required this.helperText, required this.prefixIcon,
  });

  @override
  State<ChipsWidget> createState() => _ChipsWidgetState();
}

class _ChipsWidgetState extends State<ChipsWidget> {
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: inputController,
          enabled: widget.listName.isNotEmpty,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: widget.labelText,
            helperText: widget.helperText,
            helperMaxLines: 2,
            prefixIcon: widget.prefixIcon,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final text = inputController.text.trim();
                if (text.isEmpty || (isRegex(text) && !await isValidRegexNative(text))) return;
                appState.addToFilterList(widget.listName, text); inputController.clear();
              },
            ),
          ),
        ),

        Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: -5,
          children: (appState.filterLists[widget.listName] ?? []).map((chip) {
            return Chip(
              padding: const EdgeInsets.all(5),
              labelStyle: TextStyle(color: isRegex(chip) ? Colors.teal : null),
              label: InkWell(
                onTap: () { inputController.text = chip; },
                child: Text(chip),
              ),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () { appState.removeFromFilterList(widget.listName, chip); },
            );
          }).toList(),
        ),
      ],
    );
  }
}
