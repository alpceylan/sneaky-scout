import 'package:flutter/material.dart';

// Services
import '../services/authentication_service.dart';

// Screens
import '../screens/root_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationService _authService = AuthenticationService();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _authService.getUser().displayName,
            ),
            accountEmail: Text(
              _authService.getUser().email,
            ),
          ),
          ListTile(
            leading: Icon(Icons.whatshot),
            title: Text("About Sneaky Snakes"),
            onTap: () {
              print("sneaky snakes");
            },
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text("Check app repo"),
            onTap: () {
              print("Check app repo");
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text("Go to Community Discord"),
            onTap: () {
              print("go to community discord");
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              await _authService.logout();

              Navigator.of(context).pushReplacementNamed(RootScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
