import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'package:sneakyscout/screens/auth/auth_screen.dart';
import 'package:sneakyscout/screens/home/home_screen.dart';
import 'package:sneakyscout/screens/match_scouting_detail/match_scouting_detail_screen.dart';
import 'package:sneakyscout/screens/pit_scouting_detail/pit_scouting_detail_screen.dart';
import 'package:sneakyscout/screens/root_screen.dart';

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
        primarySwatch: Colors.blue,
      ),
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
