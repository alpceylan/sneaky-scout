import 'package:flutter/material.dart';

// Services
import '../services/authentication_service.dart';

// Screens
import 'home/home_screen.dart';
import 'auth/auth_screen.dart';

class RootScreen extends StatelessWidget {
  static const routeName = '/root';

  @override
  Widget build(BuildContext context) {
    return AuthenticationService().currentUser != null
        ? HomeScreen()
        : AuthScreen();
  }
}
