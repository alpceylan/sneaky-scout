import 'package:flutter/material.dart';

// Services
import 'package:sneakyscout/services/authentication_service.dart';

// Screens
import 'package:sneakyscout/screens/auth/auth_screen.dart';
import 'package:sneakyscout/screens/home/home_screen.dart';

class RootScreen extends StatelessWidget {
  static const routeName = '/root';

  @override
  Widget build(BuildContext context) {
    return AuthenticationService().currentUser != null
        ? HomeScreen()
        : AuthScreen();
  }
}
