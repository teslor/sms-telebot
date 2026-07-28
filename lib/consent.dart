import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/generated/app_localizations.dart';
import 'constants.dart';
import 'db.dart';
import 'service.dart';
import 'state.dart';

const _itemDivider = Padding(
  padding: EdgeInsets.only(top: 10, bottom: 8),
  child: Divider(height: 1),
);

Future<void> ensureConsentAccepted(BuildContext context, AppState appState) async {
  final isAccepted = await MainDb.instance.getBoolSetting('consentAccepted');
  if (!context.mounted || isAccepted) return;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(20),
        content: const _ConsentContent(),
        actions: [
          TextButton(
            onPressed: () async {
              if (appState.isRunning) await appState.stopProcessing();
              await SystemNavigator.pop();
            },
            child: Text(AppLocalizations.of(context)!.action_exit),
          ),
          FilledButton(
            onPressed: () async {
              await MainDb.instance.saveBoolSetting('consentAccepted', true);
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: Text(AppLocalizations.of(context)!.action_continue),
          ),
        ],
      ),
    ),
  );
}

class _ConsentContent extends StatelessWidget {
  const _ConsentContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3);
    final itemStyle = textTheme.bodyMedium?.copyWith(fontSize: 13, height: 1.3);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(l10n.consent_welcome, style: titleStyle),
          const SizedBox(height: 15),

          Text(l10n.consent_item_01, style: itemStyle),
          _itemDivider,
          Text(l10n.consent_item_02, style: itemStyle),
          _itemDivider,
          Text(l10n.consent_item_03, style: itemStyle),
          _itemDivider,
          Text(l10n.consent_item_04, style: itemStyle),

          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l10n.consent_details, style: textTheme.bodyMedium?.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
              InkWell(
                onTap: () => launchURL('${AppConst.appLink}/blob/main/PRIVACY_POLICY.md'),
                child: Text(
                  l10n.consent_privacyPolicy,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.3,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
