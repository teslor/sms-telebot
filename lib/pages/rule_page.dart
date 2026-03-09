import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../state.dart';
import 'rule_connection_page.dart';
import 'rule_filters_page.dart';

class RulePage extends StatefulWidget {
  const RulePage({super.key});

  @override
  State<RulePage> createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  late TextEditingController _nameController;
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _nameController = TextEditingController(text: appState.selectedRule?['name'] ?? AppLocalizations.of(context)!.rule);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (mounted) {
          setState(() {
            _isEditing = false;
          });
        }
        _saveName();
      }
    });
  }

  void _saveName() {
    final appState = context.read<AppState>();
    final rule = appState.selectedRule;
    final newName = _nameController.text.trim();

    if (rule != null && newName.isNotEmpty && newName != rule['name']) {
      appState.updateRuleName(rule['id'], newName);
    } else if (rule != null && newName.isEmpty) {
      _nameController.text = rule['name'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          FocusManager.instance.primaryFocus?.unfocus();
          context.read<AppState>().selectRule(null);
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                appState.selectRule(null);
              },
            ),
            title: IgnorePointer(
              ignoring: !_isEditing,
              child: TextField(
                controller: _nameController,
                focusNode: _focusNode,
                readOnly: !_isEditing,
                showCursor: _isEditing,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22), // Set only the text size
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) {
                  _focusNode.unfocus();
                },
              ),
            ),
            centerTitle: true,
            elevation: 2,
            actions:[
              IconButton(
                icon: Icon(_isEditing ? Icons.check : Icons.edit),
                onPressed: () {
                  if (_isEditing) {
                    _focusNode.unfocus(); 
                  } else {
                    setState(() {
                      _isEditing = true;
                    });
                    _focusNode.requestFocus();
                  }
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: AppLocalizations.of(context)!.connection),
                Tab(text: AppLocalizations.of(context)!.filters),
              ],
            ),
          ),
          body: const TabBarView(
            children:[
              RuleConnectionPage(),
              RuleFiltersPage(),
            ],
          ),
        ),
      ),
    );
  }
}