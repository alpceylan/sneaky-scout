import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    final RoundedLoadingButtonController _btnController =
        RoundedLoadingButtonController();

    Widget _buildTextField({
      String labelText,
      Icon icon,
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Sneaky Scout"),
      ),
      body: Form(
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
                ),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              _buildTextField(
                labelText: "Mail",
                icon: Icon(
                  Icons.mail_outline,
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              _buildTextField(
                labelText: "Password",
                icon: Icon(
                  Icons.lock_outline,
                ),
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
                onPressed: () async {
                  _btnController.success();
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
