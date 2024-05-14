import 'package:flutter/material.dart';
import 'package:flutter_messaging_app/screens/screens.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool toggleLogin = true;

  void toggleScreen() {
    toggleLogin = !toggleLogin;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return toggleLogin
        ? LoginScreen(onTap: toggleScreen)
        : RegisterScreen(onTap: toggleScreen);
  }
}
