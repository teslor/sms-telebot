import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../constants.dart';
import '../service.dart';

enum Channel { telegram, ntfy, smtp, sms }
const linkColor = Color.fromARGB(255, 0, 75, 204);

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  Channel _selectedChannel = Channel.telegram;
  final List<(Channel, String)> _channelTabs = const [
    (Channel.telegram, 'Telegram'),
    (Channel.ntfy, 'ntfy'),
    (Channel.smtp, 'SMTP'),
    (Channel.sms, 'SMS'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appLabelColor = Theme.of(context).colorScheme.secondary;
    final sectionTitleStyle = TextStyle(fontSize: 18, height: 2);
    final sectionSubtitleStyle = TextStyle(fontSize: 16, height: 2);

    final infoItems = [
      l10n.help_info_01,
      l10n.help_info_02,
      l10n.help_info_03,
    ];
    final optsItems = [
      l10n.help_opts_01,
      l10n.help_opts_02,
      l10n.help_opts_03,
      {
        'text': l10n.help_opts_04, 'link': l10n.help_opts_04h,
        'url': '$appLink/raw/refs/heads/main/templates/message_basic.jsonc',
      },
      l10n.help_opts_05,
      l10n.help_opts_06,
    ];
    final tbotItems = [
      l10n.help_tbot_01,
      l10n.help_tbot_02,
      l10n.help_tbot_03,
      l10n.help_tbot_04,
    ];
    final ntfyItems = [
      l10n.help_ntfy_01('$ntfyUrl/app'),
      l10n.help_ntfy_02,
      l10n.help_ntfy_03,
      l10n.help_ntfy_04,
    ];
    final smtpItems = [
      l10n.help_smtp_01,
      l10n.help_smtp_02,
    ];
    final smsItems = [
      l10n.help_sms_01,
      l10n.help_sms_02,
      l10n.help_sms_03,
    ];
    final filterItems = [
      l10n.help_filters_01,
      l10n.help_filters_02,
      l10n.help_filters_03,
      l10n.help_filters_04,
      l10n.help_filters_05,
    ];
    final optionsItems = [
      l10n.help_options_01,
    ];

    final Color selectedChannelColor = Theme.of(context).colorScheme.primary;
    final selectedItems = [
      ...switch (_selectedChannel) {
        Channel.telegram => tbotItems,
        Channel.ntfy => ntfyItems,
        Channel.smtp => smtpItems,
        Channel.sms => smsItems,
      },
      l10n.help_rule_01,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.help_about),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          children: [
            Text(appName, style: TextStyle(fontSize: 20, color: appLabelColor)),
            Transform.translate(
              offset: const Offset(0, -5),
              child: Row(
                children: [
                  Text('$appVersion, ', style: TextStyle(color: appLabelColor)),
                  InkWell(
                    onTap: () { launchURL(appLink); },
                    child: Row(
                      children: [
                        Text('GitHub', style: TextStyle(color: linkColor, decorationColor: linkColor, decoration: TextDecoration.underline )),
                        Icon(Icons.star_border_rounded, color: linkColor, size: 14, applyTextScaling: true),
                      ],
                    )
                  ),
                ],
              ),
            ),
            Text(l10n.help_appInfo),
            const SizedBox(height: 10),

            Text(l10n.help_info, style: sectionTitleStyle),
            GuideList(items: infoItems, warnIndices: []),

            Text(l10n.settings, style: sectionTitleStyle),
            GuideList(items: optsItems, warnIndices: [5]),

            Text(l10n.rules_setup, style: sectionTitleStyle),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: _channelTabs.map((tab) {
                  final (channel, label) = tab;
                  final isSelected = channel == _selectedChannel;
                  final textColor = isSelected ? selectedChannelColor : Theme.of(context).textTheme.bodyMedium?.color;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          if (!isSelected) setState(() => _selectedChannel = channel);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Theme.of(context).colorScheme.surfaceContainerHighest : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            label, style: TextStyle(fontSize: 15, color: textColor),
                            textAlign: TextAlign.center,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            GuideList(items: selectedItems, warnIndices: []),

            Text(l10n.help_filters, style: sectionSubtitleStyle),
            GuideList(items: filterItems, warnIndices: [4]),

            Text(l10n.options, style: sectionSubtitleStyle),
            GuideList(items: optionsItems, warnIndices: []),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

class GuideList extends StatelessWidget {
  const GuideList({
    super.key,
    required this.items,
    required this.warnIndices,
  });

  final List<Object> items;
  final List<int> warnIndices;

  @override
  Widget build(BuildContext context) {
    final itemTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: 13,
      height: 1.4,
    );
    final linkStyle = itemTextStyle?.copyWith(
      color: linkColor,
      decorationColor: linkColor,
      decoration: TextDecoration.underline,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        final item = items[index];
        final data = item is String ? null : item as Map<String, dynamic>;
        final text = item is String ? item : data!['text'] as String;
        final link = data?['link'] as String?;
        final url = data?['url'] as String?;

        return ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: warnIndices.contains(index) ?
            const Icon(Icons.info_outline_rounded, color: Colors.blueAccent, size: 18, applyTextScaling: true) :
            const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 18, applyTextScaling: true),
          minLeadingWidth: 18,
          subtitle: link != null && url != null
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text, style: itemTextStyle),
                InkWell(onTap: () => launchURL(url), child: Text(link, style: linkStyle)),
              ],
            )
            : Text(text, style: itemTextStyle),
        );
      }),
    );
  }
}
