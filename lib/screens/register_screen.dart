import 'package:flutter/material.dart';
import 'package:flutter_messaging_app/components/my_button.dart';
import 'package:flutter_messaging_app/components/my_sized_box.dart';
import 'package:flutter_messaging_app/components/my_text_field.dart';
import 'package:flutter_messaging_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final void Function() onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signUp() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in your email"),
        ),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password don't match. Please try again"),
        ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontScale = MediaQuery.of(context).size.height / 900;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // icon logo
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Icon(
                    Icons.message,
                    size: 100,
                  ),
                ),

                // login message
                Text(
                  "Register and join us now!",
                  style: TextStyle(
                      fontSize: 24 * fontScale, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                const MySizedBox(
                  height: 40,
                ),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                ),

                const MySizedBox(
                  height: 10,
                ),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const MySizedBox(
                  height: 10,
                ),

                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm password",
                  obscureText: true,
                ),

                const MySizedBox(
                  height: 40,
                ),

                // sign up button
                MyButton(onTap: signUp, text: "Sign up"),

                const MySizedBox(
                  height: 40,
                ),

                // register now button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16 * fontScale),
                    ),
                    const MySizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 16 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
