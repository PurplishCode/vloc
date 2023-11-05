import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vloc/authentication_wrapper.dart';
import 'package:vloc/firebase_options.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vloc/location_map.dart';
import 'package:vloc/login_page.dart';
import 'package:vloc/provider.dart';
import 'package:vloc/routers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (error) {
    print('$error Failed to initialized.');
  }

  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: MaterialApp(
        debugShowCheckedModeBanner: false, home: AuthenticationWrapper()),
  ));
}

class MyLocation extends StatefulWidget {
  MyLocation({super.key});

  @override
  State<MyLocation> createState() => MyReallocation();
}

class MyReallocation extends State<MyLocation> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Navigator(
          onGenerateRoute: getUsersRoute,
          initialRoute: MySuperLocation.myroute),
    );
  }
}
