import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'package:sneakyscout/screens/auth/auth_screen.dart';
import 'package:sneakyscout/screens/home/home_screen.dart';
import 'package:sneakyscout/screens/match_scouting_detail/match_scouting_detail_screen.dart';
import 'package:sneakyscout/screens/pit_scouting_detail/pit_scouting_detail_screen.dart';
import 'package:sneakyscout/screens/root_screen.dart';

// Helpers
import 'package:sneakyscout/helpers/extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color darkThemeBg = HexColor.fromHex("#121212");
  final Color darkThemeCanvas = HexColor.fromHex("#313131");
  final Color darkThemeCard = HexColor.fromHex("#2B2B2B");
  final Color darkThemePrimary = HexColor.fromHex("#2B9C58");
  final Color darkThemeButton = HexColor.fromHex("#35BE6B");
  final Color darkThemeHint = HexColor.fromHex("#121212");
  final Color darkThemeTextSelection = HexColor.fromHex("#D0D0D0");
  final Color darkThemeTextSelectionHandle = HexColor.fromHex("#BDBDBD");
  final Color darkThemeShadow = HexColor.fromHex("#7E7E7E");
  final Color darkThemeIndicator = HexColor.fromHex("#739E68");

  final Color lightThemeBg = HexColor.fromHex("#F8F8F8");
  final Color lightThemeCanvas = HexColor.fromHex("#FFFFFF");
  final Color lightThemePrimary = HexColor.fromHex("#00E676");
  final Color lightThemeButton = HexColor.fromHex("#00E676");
  final Color lightThemeHint = HexColor.fromHex("#F8F8F8");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sneaky Scout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: lightThemePrimary,
        backgroundColor: lightThemeBg,
        canvasColor: lightThemeCanvas,
        buttonColor: lightThemeButton,
        hintColor: lightThemeHint,
      ),
      darkTheme: ThemeData(
        primaryColor: darkThemePrimary,
        backgroundColor: darkThemeBg,
        canvasColor: darkThemeCanvas,
        cardColor: darkThemeCard,
        buttonColor: darkThemeButton,
        hintColor: darkThemeHint,
        textSelectionColor: darkThemeTextSelection,
        textSelectionHandleColor: darkThemeTextSelectionHandle,
        shadowColor: darkThemeShadow,
        indicatorColor: darkThemeIndicator,
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
