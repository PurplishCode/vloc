import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vloc/GlobalVariables.dart';
import 'package:vloc/location_map.dart';

import 'package:vloc/provider.dart';

class LoginPage extends StatefulWidget {
  static const routesName = "/loginpages";
  @override
  State<LoginPage> createState() => MyLoginPage();
}

class MyLoginPage extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      final UserProvider userProvider =
          // ignore: use_build_context_synchronously
          Provider.of<UserProvider>(context, listen: false);
      if (user != null) {
        print("Succesfully logged in as ${user.email}");

        userProvider.setUser(user.uid);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => MySuperLocation()));
      }
    } catch (e) {
      print("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("V-Location LOGIN"),
            backgroundColor: GlobalVar.primaryColors,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          label: Text("Email"),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIconColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          fillColor: Colors.grey,
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5))),
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  width: 300,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        label: Text("Password"),
                        filled: true,
                        fillColor: Colors.grey,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        prefixIconColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () => _signInWithEmailAndPassword(context),
                      child: Text("LOGIN")),
                )
              ],
            ),
          ),
        ));
  }
}
