import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_messaging_app/screens/screens.dart";
import "package:flutter_messaging_app/services/auth/login_or_register.dart";

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginOrRegister();
        }
      }),
    );
  }
}
