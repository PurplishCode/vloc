import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
// import 'package:provider/provider.dart';
import 'package:vloc/GlobalVariables.dart';
import 'package:vloc/login_page.dart';
// import 'package:vloc/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as locationLoc;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MySuperLocation extends StatefulWidget {
  const MySuperLocation({super.key});
  static const String myroute = "/locationmap";
  final title = "VL";

  @override
  State<MySuperLocation> createState() => ThisLocation();
}

class ThisLocation extends State<MySuperLocation> {
  LatLng centerLatlng = LatLng(-5.3430, 105.2485);
  locationLoc.Location location = locationLoc.Location();
  // late LocationData locationData;
  bool permissionGranted = false;
  MapController mapController = MapController();

  List<Marker> markers = [];
  // DatabaseReference? _userLocationRef;
  double? userLongitude;
  double? userLatitude;
  String? _getAddress;
  String? _getSupersAddress;
// Checking Location Application, is it enabled?
  Future<void> permissionCheck() async {
    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      setState(() {
        permissionGranted = true;
      });
      _getCurrentLocation();
    } else if (status == PermissionStatus.denied) {
      await openAppSettings();
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  void _initMarkers() {
    markers.add(
      Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        builder: (ctx) => Container(
          child: Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40.0,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    permissionCheck();
    getMyLocation();
    mapController = MapController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _initFirebase() {
  //   final UserProvider userProvider = Provider.of<UserProvider>(context);
  //   final userData = userProvider.userData;

  //   _userLocationRef =
  //       FirebaseDatabase.instance.ref().child("locations").child(userData!.uid);

  //   _userLocationRef!.onValue.listen((event) {
  //     if (event.snapshot.value != null) {
  //       var locationData = event.snapshot.value as Map<dynamic, dynamic>;

  //       setState(() {});
  //     }
  //   });
  // }

  final database = FirebaseDatabase.instance
      .ref(); // This gives a reference to our ROOT of database. (Reference is similarly like a PATH to certain LOCATION within our database.. And in this context, it's pointing at the top of our tree.)

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
  }

  // Future<void> setLocation() async {
  //   return showDialog<void>(
  //       context: context,
  //       builder: ((context) {
  //         return AlertDialog();
  //       }));
  // }
  // Location getCurrentLocation
  String? address = '';

  Future<void> _getCurrentLocation() async {
    var locationData = await location.getLocation();

    userLatitude = locationData.latitude;
    userLongitude = locationData.longitude;

    print("LATITUDE: $userLatitude LONGITUDE: $userLongitude");
    setState(() {
      centerLatlng = LatLng(userLatitude!, userLongitude!);
      markers.clear();
      _initMarkers();
      getCurrentAddress();
    });

    mapController.move(centerLatlng, 17);
  }

  Future<void> getCurrentAddress() async {
    try {
      var locationData = await location.getLocation();

      userLatitude = locationData.latitude;
      userLongitude = locationData.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(userLatitude!, userLongitude!);
      Placemark places = placemarks[0];
      setState(() {
        _getAddress =
            "Locality: ${places.locality}\n PostalCode: ${places.postalCode}\n Country: ${places.country}\n Streets:${places.street}";
      });
    } catch (e) {
      print("$e");
    }
  }

  Position? _currentPosition;

  void updateAddress(String? newAddress) {
    setState(() {
      address = newAddress;
    });

  }
  @override
  Widget build(BuildContext context) {
//  final UserProvider userProvider = Provider.of<UserProvider>(context);
//     final userData = userProvider.userData;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "VL",
              style:
                  TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.purple,
            actions: [
              Container(
                width: 100,
                child: ElevatedButton.icon(
                  onPressed: () {
                    logout(context);
                  },
                  icon: Icon(Icons.exit_to_app),
                  label: Text("LOGOUT"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                ),
              )
            ],
          ),
          body: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              // center: _currentPosition != null
              //     ? LatLng(
              //         _currentPosition!.latitude, _currentPosition!.longitude)
              //     : centerLatlng,
              center: centerLatlng ?? LatLng(0,0),
              zoom: 17,
            ),
            nonRotatedChildren: [
              initialAddress(AddressString: _getAddress!)
            ],
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: markers),

            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              getMyLocation();
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (_) => OpenSettings()));
              // OpenSettings();
            },
            child: Icon(Icons.settings),
          ),
        ));
  }

// GeoLOcator getCurrentPosition.
  getMyLocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;

// ignore: avoid_print
        print(
            "Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}");
        markers.clear();
        _initMarkers();

        getSuperAddress();



        }, );
      Future.delayed(Duration(milliseconds: 100), () {
        mapController.move(centerLatlng, 17);
      });

      updateAddress(_getAddress);
    });

  }

  Future<void> getSuperAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark places = placemarks[0];
      setState(() {
        _getSupersAddress =
            "Locality: ${places.locality}\n PostalCode: ${places.postalCode}\n Country: ${places.country}\n Streets:${places.street} ";
      });
    } catch (e) {
      print(e);
    }
  }
}

class OpenSettings extends StatefulWidget {
  const OpenSettings({Key? key});

  @override
  State<OpenSettings> createState() => Settings();
}

class Settings extends State<OpenSettings> {
  Future<void> permissionCheck() async {
    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      await Permission.locationAlways.request();
    } else if (status == PermissionStatus.denied) {
      await openAppSettings();
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    locationLoc.Location location = locationLoc.Location();

    try {
      var locationData = await location.getLocation();

      double longitude = locationData.longitude!;
      double latitude = locationData.latitude!;

      print("Longitude: $longitude, Latitude: $latitude");
    } catch (e) {
      print("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("App Settings"),
            backgroundColor: GlobalVar.primaryColors),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Welcome",
              style: TextStyle(fontFamily: "Roboto", fontSize: 20),
            ),
            TextButton(
                onPressed: () {
                  permissionCheck();
                },
                child: Text("Permissions")),
            SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  _getCurrentLocation();
                },
                child: Text("Get my current Location.")),
          ],
        ));
  }
}

class initialAddress extends StatefulWidget {
String AddressString;

initialAddress({required this.AddressString});

  @override
  State<initialAddress> createState() => getMyAddress();
}

class getMyAddress extends State<initialAddress> {
  late String address;

  getMyAddress({Key? key});

  void initState() {
    super.initState();
    address = widget.AddressString;
  }

  void updateAddress(String newAddress) {
    setState(() {
      address = newAddress;
    });

  }


  @override
  Widget build(BuildContext context) {
    return TextSourceAttribution(address,textStyle: TextStyle(fontWeight: FontWeight.bold), );
  }


}
