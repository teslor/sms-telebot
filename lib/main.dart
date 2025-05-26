import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'styles.dart';
import 'pages/sms_page.dart';
import 'pages/bot_page.dart';
import 'pages/filters_page.dart';

const appLabel = 'SMS Telebot';
const appVersion = '0.2.0';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(App());
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: appLabel,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 1, 85, 113)
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: CustomStyle.elevatedButtonStyle,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const Color.fromARGB(255, 20, 39, 211)
            ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: CustomStyle.elevatedButtonStyle,
          ),
        ),
        home: const AppView(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      )
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(appLabel),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline_rounded),
            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen())); },
          ),
        ],        
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() { currentPageIndex = index; });
        },
        indicatorColor: theme.colorScheme.inversePrimary,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.messenger),
            icon: const Icon(Icons.messenger_outline_outlined),
            label: AppLocalizations.of(context)!.sms,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: AppLocalizations.of(context)!.bot,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.filter_alt),
            icon: Icon(Icons.filter_alt_outlined),
            label: AppLocalizations.of(context)!.filters,
          ),
        ],
      ),
      body:
        <Widget>[
          const SmsPage(),
          const BotPage(),
          const FiltersPage(),
        ][currentPageIndex],
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
          Text(appLabel, style: TextStyle(fontSize: 20, color: theme.colorScheme.secondary)),
          Transform.translate(
            offset: const Offset(0, -5),
            child: Text(appVersion ,style: TextStyle(color: theme.colorScheme.secondary)),
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