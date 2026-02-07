import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../widgets/action_button.dart';

class SmsPage extends StatelessWidget {
  const SmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final smsReceived = appState.smsReceived;
    final smsSentToBot = appState.smsSentToBot;
    final latestSms = appState.latestSms;

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
            ) : smsReceived == 0 ? Center(
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
                    _buildSmsCard(context, '${AppLocalizations.of(context)!.sms_received}:', smsReceived.toString()),
                    SizedBox(width: 10),
                    _buildSmsCard(context, '${AppLocalizations.of(context)!.sms_sent}:', smsSentToBot.toString()),
                  ],
                ),
                SizedBox(height: 15),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.sms_receivedRecently}:',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
                            TextSpan(text: '${latestSms['sender']}: ', style: TextStyle(fontWeight: FontWeight.w500)),
                            TextSpan(text: latestSms['sms']),
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
            onPressed: () async {
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