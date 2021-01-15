import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'package:sneakyscout/screens/auth/auth_screen.dart';
import 'package:sneakyscout/screens/home/home_screen.dart';
import 'package:sneakyscout/screens/match_scouting_detail/match_scouting_detail_screen.dart';
import 'package:sneakyscout/screens/pit_scouting_detail/pit_scouting_detail_screen.dart';
import 'package:sneakyscout/screens/root_screen.dart';

// Helpers
import 'package:sneakyscout/helpers/custom_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sneaky Scout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: CustomColors.lightThemePrimary,
        backgroundColor: CustomColors.lightThemeBg,
        canvasColor: CustomColors.lightThemeCanvas,
        cardColor: CustomColors.lightThemeCard,
        buttonColor: CustomColors.lightThemeButton,
        hintColor: CustomColors.lightThemeHint,
        textSelectionColor: CustomColors.lightThemeTextSelection,
        textSelectionHandleColor: CustomColors.lightThemeTextSelectionHandle,
        shadowColor: CustomColors.lightThemeShadow,
        indicatorColor: CustomColors.lightThemeIndicator,
        highlightColor: CustomColors.lightThemeHighlight,
      ),
      darkTheme: ThemeData(
        primaryColor: CustomColors.darkThemePrimary,
        backgroundColor: CustomColors.darkThemeBg,
        canvasColor: CustomColors.darkThemeCanvas,
        cardColor: CustomColors.darkThemeCard,
        buttonColor: CustomColors.darkThemeButton,
        hintColor: CustomColors.darkThemeHint,
        textSelectionColor: CustomColors.darkThemeTextSelection,
        textSelectionHandleColor: CustomColors.darkThemeTextSelectionHandle,
        shadowColor: CustomColors.darkThemeShadow,
        indicatorColor: CustomColors.darkThemeIndicator,
        highlightColor: CustomColors.darkThemeHighlight,
      ),
      themeMode: ThemeMode.dark,
      home: RootScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        MatchScoutingDetailScreen.routeName: (ctx) =>
            MatchScoutingDetailScreen(),
        PitScoutingDetailScreen.routeName: (ctx) => PitScoutingDetailScreen(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
        RootScreen.routeName: (ctx) => RootScreen(),
      },
    );
  }
}
