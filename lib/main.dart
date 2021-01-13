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
  final Color lightThemeBg = HexColor.fromHex("#FFFFFF");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sneaky Scout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: lightThemeBg,
      ),
      darkTheme: ThemeData(
        primaryColor: darkThemeBg,
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
