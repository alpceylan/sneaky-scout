import 'package:flutter/material.dart';

// Screens
import './screens/home_screen.dart';
import './screens/match_scouting_detail_screen.dart';
import './screens/pit_scouting_detail_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sneaky Scout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        MatchScoutingDetailScreen.routeName: (ctx) =>
            MatchScoutingDetailScreen(),
        PitScoutingDetailScreen.routeName: (ctx) => PitScoutingDetailScreen(),
      },
    );
  }
}
