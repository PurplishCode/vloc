import 'package:flutter/material.dart';
import 'package:vloc/location_map.dart';
import 'package:vloc/login_page.dart';

Route<dynamic> getUsersRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case (MySuperLocation.myroute):
      return MaterialPageRoute(builder: (_) => MySuperLocation());

    case (LoginPage.routesName):
      return MaterialPageRoute(builder: (_) => LoginPage());
    default:
      return MaterialPageRoute(
          builder: (_) => MaterialApp(
                  home: Scaffold(
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No such ROUTE was found.",
                        style: TextStyle(fontSize: 50),
                      )
                    ]),
              )));
  }
}
