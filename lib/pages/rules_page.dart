import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../state.dart';
import 'rule_page.dart';

class RulesMainPage extends StatelessWidget {
  const RulesMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (appState.selectedRule != null) {
      return const RulePage();
    }
    return const RulesPage();
  }
}

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final rules = appState.rules;

    return Scaffold(
      body: rules.isEmpty
        ? Center(
            child: Text(AppLocalizations.of(context)!.rules_empty, style: TextStyle(fontSize: 18)),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: rules.length,
            itemBuilder: (context, index) {
              final rule = rules[index];
              return RuleCard(rule: rule);
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appState.addRule();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RuleCard extends StatelessWidget {
  final Map<String, dynamic> rule;
  const RuleCard({super.key, required this.rule});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final isActive = rule['is_active'] == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          appState.selectRule(rule);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children:[
              Expanded(
                child: Text(
                  rule['name'] ?? AppLocalizations.of(context)!.rule,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Switch(
                value: isActive,
                activeColor: Colors.green,
                onChanged: (value) {
                  appState.toggleRuleActive(rule['id'], value);
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      // title: Text(AppLocalizations.of(context)!.connection),
                      content: Text(AppLocalizations.of(context)!.rule_confirmDelete),
                      actions:[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(AppLocalizations.of(context)!.action_cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            appState.deleteRule(rule['id']);
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context)!.action_delete, style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}