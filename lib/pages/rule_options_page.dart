import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../styles.dart';
import '../state.dart';
import '../widgets/action_button.dart';

class RuleOptionsPage extends StatefulWidget {
  const RuleOptionsPage({super.key});

  @override
  State<RuleOptionsPage> createState() => _RuleOptionsPageState();
}

class _RuleOptionsPageState extends State<RuleOptionsPage> {
  int _priority = 3;
  bool _isInputChanged = false;
  bool? _saveResult;

  Widget _priorityDot(int priority) {
    return Transform.translate(
      offset: const Offset(3, 0),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: CustomColor.priorityColor(priority),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _priority = context.read<AppState>().priority;
  }

  Future<void> _save() async {
    final appState = context.read<AppState>();
    await appState.updateRuleOptions(_priority);
    if (!mounted) return;
    setState(() {
      _isInputChanged = false;
      _saveResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final priorityOptions = <(int, String)>[
      (1, l10n.options_priority_01),
      (2, l10n.options_priority_02),
      (3, l10n.options_priority_03),
      (4, l10n.options_priority_04),
      (5, l10n.options_priority_05),
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: [
          DropdownMenu<int>(
            initialSelection: _priority,
            expandedInsets: EdgeInsets.zero,
            label: Text(l10n.options_priority),
            inputDecorationTheme: CustomStyle.compactDropdown,
            dropdownMenuEntries: priorityOptions
                .map((option) => DropdownMenuEntry<int>(
                    value: option.$1,
                    label: option.$2,
                    leadingIcon: _priorityDot(option.$1),
                    style: CustomStyle.compactDropdownItem,
                  ))
                .toList(growable: false),
            onSelected: (value) {
              if (value == null || value == _priority) return;
              setState(() {
                _priority = value;
                _isInputChanged = true;
                _saveResult = null;
              });
            },
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              l10n.options_priorityInfo,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: ActionButton(
        label: l10n.action_save,
        onPressed: _isInputChanged ? _save : null,
        isSuccess: _saveResult,
      ),
    );
  }
}
