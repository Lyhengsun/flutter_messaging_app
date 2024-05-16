import 'package:flutter/material.dart';
import 'package:flutter_messaging_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final double displayScale = MediaQuery.of(context).size.height / 900;
    final double header1Size = 24 * displayScale;
    final double header2Size = 16 * displayScale;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: header1Size,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: signOut,
              icon: Icon(
                Icons.logout_sharp,
                color: Colors.white,
                size: 28 * displayScale,
              ))
        ],
      ),
    );
  }
}
