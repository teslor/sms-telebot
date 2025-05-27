import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          Text(AppConst.appName, style: TextStyle(fontSize: 20, color: theme.colorScheme.secondary)),
          Transform.translate(
            offset: const Offset(0, -5),
            child: Text(AppConst.appVersion ,style: TextStyle(color: theme.colorScheme.secondary)),
          ),
          Text(AppLocalizations.of(context)!.help_appInfo),
          const SizedBox(height: 10),

          Center(child: Text(AppLocalizations.of(context)!.help_howToUse,style: TextStyle(fontSize: 18, height: 2.5))),
          GuideList(items: guideItems),

          Center(child: Text(AppLocalizations.of(context)!.help_filters,style: TextStyle(fontSize: 18, height: 2.5))),
          GuideList(items: filterItems),
        ],
      ),
    );
  }
}

class GuideList extends StatelessWidget {
  const GuideList({
    super.key,
    required this.items,
  });

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const Icon(Icons.check_circle_outline_rounded, size: 15),
          minLeadingWidth: 15,
          subtitle: Text(items[index]),
        );
      }),
    );
  }
}