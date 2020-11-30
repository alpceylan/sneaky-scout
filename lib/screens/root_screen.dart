import 'package:flutter/material.dart';

// Services
import '../services/authentication_service.dart';

// Screens
import '../screens/home_screen.dart';
import '../screens/auth_screen.dart';

class RootScreen extends StatefulWidget {
  static const routeName = '/root';

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authService.getUser(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data != null) {
          return HomeScreen();
        }
        return AuthScreen();
      },
    );
  }
}
