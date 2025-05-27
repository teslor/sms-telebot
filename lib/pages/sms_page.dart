import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../state.dart';

class SmsPage extends StatelessWidget {
  const SmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final smsReceived = appState.smsReceived;
    final smsSentToBot = appState.smsSentToBot;
    final latestSms = appState.latestSms;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: smsReceived == 0 ? Center(child: Text(AppLocalizations.of(context)!.sms_empty, textAlign: TextAlign.center, style: TextStyle(fontSize: 18))) : Column(
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
            child: ListTile(
              title: Text('${AppLocalizations.of(context)!.sms_latest} ${latestSms['sender']}):'),
              subtitle: Text(latestSms['sms'])
            ),
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
              Text(value, style: TextStyle(fontSize: 22), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}