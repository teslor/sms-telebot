import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../state.dart';
import '../widgets/action_button.dart';
import 'connections/registry.dart';
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

  String _providerName(String provider, AppLocalizations l10n) {
    return switch (provider) {
      'telegram_bot' => l10n.telebot,
      'smtp_server' => l10n.smtp,
      _ => provider,
    };
  }

  IconData _providerIcon(String provider) {
    return switch (provider) {
      'telegram_bot' => Icons.telegram,
      'smtp_server' => Icons.mail_outline,
      _ => Icons.extension,
    };
  }

  Future<String?> _showProviderPicker(BuildContext context) {
    final providers = connectionProviders.keys.toList(growable: false);

    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: providers.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (itemContext, index) {
            final provider = providers[index];
            final l10n = AppLocalizations.of(itemContext)!;
            final name = _providerName(provider, l10n);
            return ListTile(
              leading: Icon(_providerIcon(provider)),
              title: Text(name),
              onTap: () => Navigator.pop(sheetContext, provider),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final rules = appState.rules;

    return Scaffold(
      body: rules.isEmpty
        ? Center(
          child: Text(
            AppLocalizations.of(context)!.rules_empty,
            style: TextStyle(fontSize: 18),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: rules.length,
          itemBuilder: (context, index) {
            final rule = rules[index];
            return RuleCard(rule: rule);
          },
        ),

      bottomNavigationBar: ActionButton(
        label: AppLocalizations.of(context)!.rule_add,
        isSuccess: null,
        onPressed: () async {
          final selectedProvider = await _showProviderPicker(context);
          if (selectedProvider == null || !context.mounted) return;
          final l10n = AppLocalizations.of(context)!;
          final name = _providerName(selectedProvider, l10n);
          await appState.addRule(provider: selectedProvider, name: name, autoSelect: true);
        },
      ),
    );
  }
}

class RuleCard extends StatelessWidget {
  final Map<String, dynamic> rule;
  const RuleCard({super.key, required this.rule});

  void _showActionMenu(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext bottomSheetContext) {
        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: 2,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (itemContext, index) {
            if (index == 0) {
              return ListTile(
                leading: const Icon(Icons.control_point_duplicate),
                title: Text(AppLocalizations.of(context)!.action_duplicate),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  appState.duplicateRule(rule);
                },
              );
            }

            return ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                AppLocalizations.of(context)!.action_delete,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(bottomSheetContext);

                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(
                      AppLocalizations.of(context)!.rule_deleteHeader,
                      style: const TextStyle(fontSize: 20),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rule['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(AppLocalizations.of(context)!.rule_deleteText),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(AppLocalizations.of(context)!.action_cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          appState.deleteRule(rule['id']);
                          Navigator.pop(dialogContext);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.action_delete,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

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
        onLongPress: () {
          _showActionMenu(context, appState);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
