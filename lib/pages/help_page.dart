import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants.dart';
import '../service.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLabelColor = Theme.of(context).colorScheme.secondary;

    final List<String> guideItems = [
      AppLocalizations.of(context)!.help_howToUse_01,
      AppLocalizations.of(context)!.help_howToUse_02,
      AppLocalizations.of(context)!.help_howToUse_03,
      AppLocalizations.of(context)!.help_howToUse_04,
      AppLocalizations.of(context)!.help_howToUse_05,
      AppLocalizations.of(context)!.help_howToUse_06,
    ];
    final List<String> filterItems = [
      AppLocalizations.of(context)!.help_filters_01,
      AppLocalizations.of(context)!.help_filters_02,
      AppLocalizations.of(context)!.help_filters_03,
      AppLocalizations.of(context)!.help_filters_04,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.help_about),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(25.0),
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
          Text(AppLocalizations.of(context)!.help_appInfo),
          const SizedBox(height: 10),

          Center(child: Text(AppLocalizations.of(context)!.help_howToUse,style: TextStyle(fontSize: 18, height: 2.5))),
          GuideList(items: guideItems, warnIndices: [4, 5]),

          Center(child: Text(AppLocalizations.of(context)!.help_filters,style: TextStyle(fontSize: 18, height: 2.5))),
          GuideList(items: filterItems, warnIndices: []),
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: warnIndices.contains(index) ? const Icon(Icons.error_outline_rounded, size: 18) :
                   const Icon(Icons.check_circle_outline_rounded, size: 18),
          minLeadingWidth: 18,
          subtitle: Text(items[index]),
        );
      }),
    );
  }
}