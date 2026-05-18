import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../extensions/build_context_x.dart';
import '../l10n/generated/app_localizations.dart';
import '../state.dart';
import '../service.dart';
import '../widgets/action_button.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  static const int _statusReceived = 0;
  static const int _statusFailedFinal = 1;
  static const int _statusFailedRetry = 2;
  static const int _statusSentPartial = 3;
  static const int _statusSentAll = 4;

  bool _isStarting = false;

  Future<void> _handleAction(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) async {
    if (appState.isRunning) {
      await appState.stopProcessing();
      return;
    }

    setState(() => _isStarting = true);
    bool canStart = true;
    if (appState.forwardSms && !await getSmsPermission()) canStart = false;
    if (appState.forwardCalls && !await getPhonePermission()) canStart = false;
    if (appState.enableForeground && !await getNotificationPermission()) canStart = false;

    if (!canStart) {
      setState(() => _isStarting = false);
      if (context.mounted) context.showErrorSnack(l10n.warn_permissionsRequired);
      return;
    }

    final result = await appState.startProcessing();
    setState(() => _isStarting = false);
    if (!result.isSuccess && context.mounted) {
      context.showErrorSnack(getLocalizedError(l10n, result.code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l10n = AppLocalizations.of(context)!;

    final receivedCount = appState.receivedCount;
    final sentCount = appState.sentCount;
    final messagesList = appState.messagesList;
    final isEmptyState = !appState.isRunning || receivedCount == 0;

    return Scaffold(
      body: isEmptyState
        ? Center(
          child: Text(
            !appState.isRunning ? l10n.msg_welcome : l10n.msg_empty,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        )
        : ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard(context, l10n.msg_received, receivedCount.toString()),
                const SizedBox(width: 16),
                _buildInfoCard(context, l10n.msg_sent, sentCount.toString()),
              ],
            ),
            const SizedBox(height: 16),
            if (messagesList.isNotEmpty)
              ...messagesList.map((msg) => _buildMessageCard(context, msg)),
          ],
        ),

      bottomNavigationBar: ActionButton(
        label: appState.isRunning ? l10n.msg_stop : l10n.msg_start,
        isSuccess: null,
        onPressed: (appState.canStartProcessing || appState.isRunning)
            ? () {
                if (_isStarting) return;
                _handleAction(context, appState, l10n);
              }
            : null,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value) {
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

  Widget _buildMessageCard(BuildContext context, Map<String, dynamic> msg) {
    final theme = Theme.of(context);
    final textStyleMuted = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: theme.colorScheme.onSurface.withAlpha(150));

    final type = (msg['type'] ?? 'sms').toString();
    final isSms = type == 'sms';
    final titleIcon = isSms
        ? Icons.messenger
        : (type == 'call' ? Icons.call : Icons.phonelink_setup_rounded);
    final titleIconColor = isSms
        ? Colors.amber
        : (type == 'call' ? Colors.green : theme.colorScheme.primary);
    final sender = msg['sender']?.toString() ?? '';
    final bodyText = msg['body']?.toString() ?? '';
    final receivedDate = DateFormat('dd.MM HH:mm').format(DateTime.fromMillisecondsSinceEpoch(msg['received_at']));
    final status = (msg['status'] as num?)?.toInt() ?? _statusReceived;
    final sentAt = (msg['sent_at'] as num?)?.toInt();
    final lastAttemptAt = (msg['last_attempt_at'] as num?)?.toInt();
    final activityAt = sentAt ?? lastAttemptAt;
    final activityDate = activityAt == null ? null : DateFormat('dd.MM HH:mm').format(DateTime.fromMillisecondsSinceEpoch(activityAt));
    final statusVisual = _statusVisual(theme, status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_downward_rounded, size: 12, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(receivedDate, style: textStyleMuted),
                  ],
                ),
                if (status != _statusReceived)
                  Row(
                    children: [
                      if (activityDate != null) ...[
                        Text(activityDate, style: textStyleMuted),
                        const SizedBox(width: 4),
                      ],
                      Icon(statusVisual.icon, size: 12, color: statusVisual.color),
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
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(titleIcon, size: 14, color: titleIconColor),
                    ),
                  ),
                  TextSpan(text: ' $sender', style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (bodyText.isNotEmpty) TextSpan(text: '\n$bodyText'),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({IconData icon, Color color}) _statusVisual(ThemeData theme, int status) {
    return switch (status) {
      _statusSentAll => (icon: Icons.arrow_upward_rounded, color: Colors.green.shade600),
      _statusSentPartial => (icon: Icons.arrow_upward_rounded, color: Colors.lime.shade600),
      _statusFailedRetry => (icon: Icons.autorenew_rounded, color: Colors.orange),
      _statusFailedFinal => (icon: Icons.error_outline_rounded, color: theme.colorScheme.error),
      _ => (icon: Icons.schedule_rounded, color: theme.colorScheme.onSurfaceVariant),
    };
  }
}
