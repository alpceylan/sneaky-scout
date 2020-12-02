import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Services
import '../services/authentication_service.dart';

// Screens
import '../screens/root_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationService _authService = AuthenticationService();

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    Future<void> goToLink(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw "Could not launch $url";
      }
    }

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _authService.getUser().displayName,
            ),
            accountEmail: Text(
              _authService.getUser().email,
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.03,
          ),
          ListTile(
            leading: Icon(Icons.whatshot),
            title: Text("About Sneaky Snakes"),
            onTap: () async {
              await goToLink("http://www.team7285.com/about/#whoarewe");
            },
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text("Check app repo"),
            onTap: () async {
              await goToLink("https://github.com/alpceylan/sneaky-scout");
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text("Go to Community Discord"),
            onTap: () async {
              await goToLink("https://discord.gg/ebu74U5qeF");
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
          Spacer(),
          Divider(
            endIndent: 10,
            indent: 10,
            color: Colors.grey[350],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: deviceHeight * 0.012,
              left: deviceWidth * 0.06,
              bottom: deviceHeight * 0.003,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "DOCUMENTATION",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.text_snippet),
            title: Text("Get Started"),
            onTap: () {
              print("empty for now");
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("How to use"),
            onTap: () {
              print("empty for now");
            },
          ),
          SizedBox(
            height: deviceHeight * 0.13,
          ),
        ],
      ),
    );
  }
}
