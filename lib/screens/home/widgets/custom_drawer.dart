import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

// Services
import 'package:sneakyscout/services/authentication_service.dart';

// Screens
import 'package:sneakyscout/screens/root_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationService _authService = AuthenticationService();

    ImagePicker picker = ImagePicker();

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    Future<void> goToLink(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw "Could not launch $url";
      }
    }

    Future _getImageFromCamera() async {
      final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );

      File image = File(pickedFile.path);
      await _authService.updateCurrentUserProfilePicture(image);
    }

    Future _getImageFromGallery() async {
      final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );

      File image = File(pickedFile.path);
      await _authService.updateCurrentUserProfilePicture(image);
    }

    void _showPicker(BuildContext ctx) {
      showModalBottomSheet(
        context: ctx,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                      leading: Icon(
                        Icons.photo_library,
                      ),
                      title: Text('Photo Library'),
                      onTap: () {
                        _getImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                    ),
                    title: Text('Camera'),
                    onTap: () {
                      _getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Drawer(
      child: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  backgroundImage: _authService.currentUser.photoURL != null
                      ? NetworkImage(
                          _authService.currentUser.photoURL,
                        )
                      : AssetImage(
                          "assets/images/default_profile_photo.png",
                        ),
                ),
              ),
              accountName: Text(
                _authService.currentUser.displayName,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              accountEmail: Text(
                _authService.currentUser.email,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            ListTile(
              leading: Icon(
                Icons.whatshot,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "About Sneaky Snakes",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () async {
                await goToLink("http://www.team7285.com/about/#whoarewe");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.code,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Check app repo",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () async {
                await goToLink("https://github.com/alpceylan/sneaky-scout");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Go to Community Discord",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () async {
                await goToLink("https://discord.gg/uVhBqG");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () async {
                await _authService.logout();

                Navigator.of(context)
                    .pushReplacementNamed(RootScreen.routeName);
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
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.text_snippet,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Get Started",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () {
                print("empty for now");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "How to use",
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () {
                print("empty for now");
              },
            ),
            SizedBox(
              height: deviceHeight * 0.13,
            ),
          ],
        ),
      ),
    );
  }
}
