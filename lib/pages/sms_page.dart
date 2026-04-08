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
    final smsReceivedList = appState.smsReceivedList;
    final isEmptyState = !appState.isRunning || smsReceivedCount == 0;

    return Scaffold(
      body: isEmptyState
        ? Center(
          child: Text(
            !appState.isRunning ? l10n.sms_welcome : l10n.sms_empty,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        )
        : ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmsCard(context, l10n.sms_received, smsReceivedCount.toString()),
                const SizedBox(width: 15),
                _buildSmsCard(context, l10n.sms_sent, smsSentCount.toString()),
              ],
            ),
            const SizedBox(height: 15),
            if (smsReceivedList.isNotEmpty)
              ...smsReceivedList.map((sms) => _buildRecentSmsItem(context, sms)),
          ],
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
        margin: EdgeInsets.zero,
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

  Widget _buildRecentSmsItem(BuildContext context, Map<String, dynamic> sms) {
    final theme = Theme.of(context);
    final textStyleMuted = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface.withAlpha(150));
    
    final receivedDate = DateFormat('dd.MM HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sms['received_at']));
    final isSent = sms['status'] != 0 && sms['sent_at'] != null;
    final sentDate = isSent 
        ? DateFormat('dd.MM HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sms['sent_at'])) 
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_downward_rounded, size: 14, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(receivedDate, style: textStyleMuted),
                  ],
                ),
                if (isSent)
                  Row(
                    children: [
                      Text(sentDate!, style: textStyleMuted),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.green.shade600),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 6),
            RichText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textScaler: MediaQuery.textScalerOf(context),
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14), 
                children: [
                  TextSpan(text: '${sms['sender']}: ', style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: sms['body']),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
