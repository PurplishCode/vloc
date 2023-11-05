import 'package:flutter/material.dart';

class UserData {
  final String uid;
  UserData(this.uid);
}

class UserProvider extends ChangeNotifier {
  UserData? _userData;

  void setUser(String uid) {
    _userData = UserData(uid);
    notifyListeners();
  }

  UserData? get userData => _userData;
}
