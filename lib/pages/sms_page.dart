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
    final smsReceivedCount = appState.smsReceivedCount;
    final smsSentCount = appState.smsSentCount;
    final lastSms = appState.lastSms;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
            child: !appState.isRunning ? Center(
              child: Text(
                AppLocalizations.of(context)!.sms_welcome,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ) : smsReceivedCount == 0 ? Center(
              child: Text(
                AppLocalizations.of(context)!.sms_empty,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ) : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSmsCard(context, AppLocalizations.of(context)!.sms_received, smsReceivedCount.toString()),
                    SizedBox(width: 10),
                    _buildSmsCard(context, AppLocalizations.of(context)!.sms_sent, smsSentCount.toString()),
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
                            '${AppLocalizations.of(context)!.sms_sent} • ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(lastSms['time'])))}',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            textScaler: MediaQuery.textScalerOf(context),
                            text: TextSpan(style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14), children: [
                              TextSpan(text: '${lastSms['sender']}: ', style: TextStyle(fontWeight: FontWeight.w500)),
                              TextSpan(text: lastSms['sms']),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          ActionButton(
            label: appState.isRunning ? AppLocalizations.of(context)!.sms_stop : AppLocalizations.of(context)!.sms_start,
            isSuccess: null,
            onPressed: (appState.botToken == '' || appState.chatId == '') ? null : () async {
              if (appState.isRunning) {
                await appState.stopProcessing();
              } else {
                await appState.startProcessing();
              }
            },
          ),
        ],
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