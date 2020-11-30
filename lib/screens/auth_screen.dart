import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  bool isLogin = true;

  String _name;
  int _teamNumber;
  String _mail;
  String _password;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    _validate() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print(_name ?? "qq");
        print(_teamNumber ?? "qq");
        print(_mail);
        print(_password);
        // Authentication service will be here.
        _btnController.success();
      } else {
        print("validation failed");
        _btnController.reset();
      }
    }

    Widget _buildTextField({
      String labelText,
      Icon icon,
      bool obscureText = false,
      TextInputType keyboardType = TextInputType.name,
      Function(String) onSaved,
      Function(String) validator,
    }) {
      return TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: icon,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: deviceWidth * 0.01,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: validator,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Sneaky Scout"),
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
                  _buildTextField(
                    labelText: "Name",
                    icon: Icon(
                      Icons.person_outline,
                    ),
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
                  _buildTextField(
                    labelText: "Team number",
                    icon: Icon(
                      Icons.group_outlined,
                    ),
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
                _buildTextField(
                  labelText: "Mail",
                  icon: Icon(
                    Icons.mail_outline,
                  ),
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
                _buildTextField(
                  labelText: "Password",
                  icon: Icon(
                    Icons.lock_outline,
                  ),
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
                      color: Colors.white,
                    ),
                  ),
                  controller: _btnController,
                  onPressed: _validate,
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
