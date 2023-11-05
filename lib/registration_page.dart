import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'GlobalVariables.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key});

  @override
  State<RegistrationPage> createState() => Regist();
}

class Regist extends State<RegistrationPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> signUpUser() async {
    String emailUser = _emailController.text.trim();
    String passwordUser = _passwordController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
            ),
            TextField(
              controller: _passwordController,
            )
          ],
        ),
      ),
    );
  }
}
