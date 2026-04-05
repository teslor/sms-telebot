import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/generated/app_localizations.dart';
import '../state.dart';
import '../widgets/action_button.dart';

class SmsPage extends StatelessWidget {
  const SmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l10n = AppLocalizations.of(context)!;

    final smsReceivedCount = appState.smsReceivedCount;
    final smsSentCount = appState.smsSentCount;
    final lastSms = appState.lastSms;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
              child: !appState.isRunning ? Center(
                child: Text(
                  l10n.sms_welcome,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ) : smsReceivedCount == 0 ? Center(
                child: Text(
                  l10n.sms_empty,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ) : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSmsCard(context, l10n.sms_received, smsReceivedCount.toString()),
                      SizedBox(width: 15),
                      _buildSmsCard(context, l10n.sms_sent, smsSentCount.toString()),
                    ],
                  ),
                  SizedBox(height: 15),
                  if (lastSms != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${l10n.sms_sent} • ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(lastSms['sent_at']))}',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface.withAlpha(128))
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              textScaler: MediaQuery.textScalerOf(context),
                              text: TextSpan(style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14), children: [
                                TextSpan(text: '${lastSms['sender']}: ', style: TextStyle(fontWeight: FontWeight.w500)),
                                TextSpan(text: lastSms['body']),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: ActionButton(
        label: appState.isRunning ? l10n.sms_stop : l10n.sms_start,
        isSuccess: null,
        onPressed: (!appState.canStartProcessing && !appState.isRunning) ? null : () async {
          if (appState.isRunning) {
            await appState.stopProcessing();
          } else {
            await appState.startProcessing();
          }
        },
      ),
    );
  }

  Widget _buildSmsCard(BuildContext context, String title, String value) {
    return Expanded(
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              Text(value, style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
