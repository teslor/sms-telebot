import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'state.dart';
import 'styles.dart';
import 'pages/sms_page.dart';
import 'pages/bot_page.dart';
import 'pages/filters_page.dart';
import 'pages/help_page.dart';

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
        title: AppConst.appName,
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
        title: const Text(AppConst.appName),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline_rounded),
            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage())); },
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