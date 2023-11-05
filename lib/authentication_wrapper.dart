import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vloc/location_map.dart';
import 'package:vloc/login_page.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;

            if (user == null) {
              return LoginPage();
            }
            return LoginPage();
          }
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }));
  }
}
