import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

// Services
import 'package:sneakyscout/services/authentication_service.dart';

// Screens
import 'package:sneakyscout/screens/root_screen.dart';

// Widgets
import 'package:sneakyscout/screens/auth/widgets/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  AuthenticationService _authService = AuthenticationService();

  bool isLogin = true;

  String _name;
  int _teamNumber;
  String _mail;
  String _password;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    Future<void> _save() async {
      try {
        if (isLogin) {
          await _authService.login(
            _mail,
            _password,
          );
        } else {
          await _authService.signup(
            _name,
            _teamNumber,
            _mail.toLowerCase(),
            _password,
          );
        }

        _btnController.success();
        Navigator.of(context).pushReplacementNamed(
          RootScreen.routeName,
        );
      } on FirebaseAuthException catch (error) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(error.message),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ),
          ),
        );
        _btnController.reset();
      } catch (error) {
        print(error);
        _btnController.reset();
      }
    }

    Future<void> _validate() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        await _save();
      } else {
        print("validation failed");
        _btnController.reset();
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "Sneaky Scout",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.1,
              vertical: deviceHeight * 0.1,
            ),
            child: Column(
              children: [
                if (!isLogin)
                  CustomTextField(
                    labelText: "Name",
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (!isLogin) {
                        if (value.length == 0) {
                          return "Name shouldn't be empty.";
                        }
                        return null;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _name = newValue;
                    },
                  ),
                SizedBox(
                  height: deviceHeight * 0.03,
                ),
                if (!isLogin)
                  CustomTextField(
                    labelText: "Team number",
                    icon: Icons.group_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (!isLogin) {
                        if (value.length == 0) {
                          return "Team number shouldn't be empty.";
                        } else if (int.parse(value) is int == false) {
                          return "Team number should be integer.";
                        }
                        return null;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _teamNumber = int.parse(newValue);
                    },
                  ),
                SizedBox(
                  height: deviceHeight * 0.03,
                ),
                CustomTextField(
                  labelText: "Mail",
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.length == 0) {
                      return "Mail shouldn't be empty.";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _mail = newValue;
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.03,
                ),
                CustomTextField(
                  labelText: "Password",
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value.length == 0) {
                      return "Password shouldn't be empty.";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _password = newValue;
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.1,
                ),
                RoundedLoadingButton(
                  child: Text(
                    isLogin ? 'Login' : 'Signup',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  color: Theme.of(context).buttonColor,
                  controller: _btnController,
                  onPressed: () async {
                    await _validate();
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.035,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
                        ? "Don't have an account?"
                        : "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
