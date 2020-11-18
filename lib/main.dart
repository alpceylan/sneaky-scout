import 'package:flutter/material.dart';

// Screens
import './screens/home_screen.dart';
import './screens/match_scouting_screen.dart';
import './screens/match_scouting_detail_screen.dart';

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
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        MatchScoutingScreen.routeName: (ctx) => MatchScoutingScreen(),
        MatchScoutingDetailScreen.routeName: (ctx) =>
            MatchScoutingDetailScreen(),
      },
    );
  }
}
