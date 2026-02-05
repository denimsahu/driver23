import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:driver/bloc/login_bloc.dart';
import 'package:driver/global/globalVariables.dart';
import 'package:driver/screens/animation.dart';
import 'package:driver/screens/home_screen.dart';
import 'package:driver/screens/login_screen.dart';
import 'package:driver/screens/permission_denied.dart';
import 'package:driver/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> onStart(ServiceInstance service) async {
  print("hello1" * 20);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("hello2" * 20);
  var prefs = await SharedPreferences.getInstance();
  String username = prefs.getString('username').toString();
  CollectionReference drivercollection = FirebaseFirestore.instance.collection(
    "Drivers",
  );
  late StreamSubscription<Position> liveLocationStream;
  bool liverLocationStreamRunning = false;
  print("hello3" * 20);
  await for (QuerySnapshot<Map<String, dynamic>> snapshot
      in FirebaseFirestore.instance.collection("Drivers").snapshots()) {
    for (QueryDocumentSnapshot document in snapshot.docs) {
      if (document.get("Vehicle Number") == username) {
        if (document.get("DrivingAllowed")) {
          if (!liverLocationStreamRunning) {
            liverLocationStreamRunning = true;
            liveLocationStream =
                Geolocator.getPositionStream(
                  locationSettings: LocationSettings(
                    accuracy: LocationAccuracy.high,
                  ),
                ).listen((Position position) async {
                  print('Gatting Location....');
                  String x = position.latitude.toString();
                  String y = position.longitude.toString();
                  print('sending location to database...');
                  drivercollection.doc(username).update({
                    'latitude': x.toString(),
                    'langitude': y.toString(),
                  });
                });
            if (service is AndroidServiceInstance) {
              if (await service.isForegroundService()) {
                service.setForegroundNotificationInfo(
                  title: "Tracking",
                  content: "Safe Driving.",
                );
              }
            }
          }
        } else {
          if (liverLocationStreamRunning) {
            liveLocationStream.cancel();
            exit(0);
          }
        }
      }
    }
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  backgroundService.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => splash_screen(),
          "/home": (context) => home_screen(),
          "/login": (context) => LoginScreen(),
          "/PermissinDenied": (context) => Permision_denied(),
        },
        initialRoute: "/",
      ),
    ),
  );
}
