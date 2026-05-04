import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../constants.dart';
import '../service.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appLabelColor = Theme.of(context).colorScheme.secondary;
    final sectionTitleStyle = TextStyle(fontSize: 18, height: 2);

    final List<String> infoItems = [
      l10n.help_info_01,
      l10n.help_info_02,
      l10n.help_info_03,
      l10n.help_info_04,
    ];
    final List<String> optsItems = [
      l10n.help_opts_01,
      l10n.help_opts_02,
      l10n.help_opts_03,
      l10n.help_opts_04,
    ];    
    final List<String> tbotItems = [
      l10n.help_tbot_01,
      l10n.help_tbot_02,
      l10n.help_tbot_03,
      l10n.help_tbot_04,
    ];
    final List<String> smtpItems = [
      l10n.help_smtp_01,
      l10n.help_smtp_02,
      l10n.help_smtp_03,
    ];
    final List<String> filterItems = [
      l10n.help_filters_01,
      l10n.help_filters_02,
      l10n.help_filters_03,
      l10n.help_filters_04,
      l10n.help_filters_05,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.help_about),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Text(AppConst.appName, style: TextStyle(fontSize: 20, color: appLabelColor)),
            Transform.translate(
              offset: const Offset(0, -5),
              child: Row(
                children: [
                  Text('${AppConst.appVersion}, ', style: TextStyle(color: appLabelColor)),
                  InkWell(
                    onTap: () { launchURL('https://github.com/teslor/sms-telebot'); },
                    child: Row(
                      children: [
                        Text('GitHub', style: TextStyle(color: appLabelColor, decoration: TextDecoration.underline )),
                        Icon(Icons.star_border_rounded, color: appLabelColor, size: 16),
                      ],
                    )
                  ),
                ],
              ),
            ),
            Text(l10n.help_appInfo),
            const SizedBox(height: 10),

            Text(l10n.help_info, style: sectionTitleStyle),
            GuideList(items: infoItems, warnIndices: [3]),

            Text(l10n.settings, style: sectionTitleStyle),
            GuideList(items: optsItems, warnIndices: [3]),

            Text(l10n.help_tbot, style: sectionTitleStyle),
            GuideList(items: tbotItems, warnIndices: []),

            Text(l10n.help_smtp, style: sectionTitleStyle),
            GuideList(items: smtpItems, warnIndices: []),

            Text(l10n.help_filters, style: sectionTitleStyle),
            GuideList(items: filterItems, warnIndices: [4]),
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

  final List<String> items;
  final List<int> warnIndices;

  @override
  Widget build(BuildContext context) {
    final itemTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: 13,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: warnIndices.contains(index) ? const Icon(Icons.info_outline_rounded, color: Colors.blueAccent, size: 18) :
                   const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 18),
          minLeadingWidth: 18,
          subtitle: Text(items[index], style: itemTextStyle),
        );
      }),
    );
  }
}
