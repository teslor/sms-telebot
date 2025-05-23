import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../utils.dart';
import '../widgets/action_button.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  final GlobalKey<_ChipsWidgetState> _senderChipsKey = GlobalKey<_ChipsWidgetState>();
  final GlobalKey<_ChipsWidgetState> _smsChipsKey = GlobalKey<_ChipsWidgetState>();
  bool? _testResult;
  bool? _saveResult;

  void _testFilters() async {
    final appState = context.read<AppState>();
    setState(() { 
      _testResult = appState.checkFilters(_senderChipsKey.currentState?.inputController.text ?? '',
                  _smsChipsKey.currentState?.inputController.text ?? '');
    });
  }

   void _saveFilters() async {
    final appState = context.read<AppState>();
    appState.saveFilters();
    setState(() { _saveResult = true; });
  } 

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                SegmentedButton<int>(
                  showSelectedIcon: false,
                  style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12))),
                  segments: <ButtonSegment<int>>[
                    ButtonSegment<int>(value: 0, label: Text(AppLocalizations.of(context)!.filters_off, textAlign: TextAlign.center, style: TextStyle(height: 1.15))),
                    ButtonSegment<int>(value: 1, label: Text(AppLocalizations.of(context)!.filters_whiteList, textAlign: TextAlign.center, style: TextStyle(height: 1.15))),
                    ButtonSegment<int>(value: 2, label: Text(AppLocalizations.of(context)!.filters_blackList, textAlign: TextAlign.center, style: TextStyle(height: 1.15))),
                  ],
                  selected: <int>{appState.filterMode},
                  onSelectionChanged: (Set<int> newSelection) {
                    appState.updateFilterMode(newSelection.first);
                  },
                ),
                
                const SizedBox(height: 15),
                
                ChipsWidget(
                  key: _senderChipsKey,
                  listName: appState.filterMode == 1 ? 'wSenders' : appState.filterMode == 2 ? 'bSenders' : '',
                  labelText: AppLocalizations.of(context)!.filters_sender,
                  helperText: AppLocalizations.of(context)!.filters_senderInfo,
                  prefixIcon: const Icon(Icons.person_outline_rounded)
                ),
                
                const SizedBox(height: 20),
                
                ChipsWidget(
                  key: _smsChipsKey,
                  listName: appState.filterMode == 1 ? 'wSms' : appState.filterMode == 2 ? 'bSms' : '',
                  labelText: AppLocalizations.of(context)!.filters_text,
                  helperText: AppLocalizations.of(context)!.filters_textInfo,
                  prefixIcon: const Icon(Icons.sms_outlined)
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: ActionButton(
                label: AppLocalizations.of(context)!.filters_test,
                onPressed: _testFilters,
                isSuccess: _testResult
              )),

              const SizedBox(width: 15),

              Expanded(child: ActionButton(
                label: AppLocalizations.of(context)!.filters_save,
                onPressed: _saveFilters,
                isSuccess: _saveResult
              ))
            ],
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
          enabled: appState.filterMode != 0,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.labelText,
            helperText: widget.helperText,
            helperMaxLines: 2,
            prefixIcon: widget.prefixIcon,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final text = inputController.text.trim();
                if (text.isEmpty || (isRegex(text) && !isValidRegex(text))) return;
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
              label: InkWell(
                onTap: () { inputController.text = chip; },
                child: Text(chip),
              ),
              deleteIcon: Icon(Icons.close),
              onDeleted: () { appState.removeFromFilterList(widget.listName, chip); },
            );
          }).toList(),
        ),
      ],
    );
  }
}