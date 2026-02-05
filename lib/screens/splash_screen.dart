import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash_screen extends StatefulWidget {
  splash_screen({super.key});
  int i = 0;
  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  String data = 'Starting app please wait...';
  @override
  void initState() {
    getcurrentuser();
  }

  getcurrentuser() async {
    var prefs = await SharedPreferences.getInstance();
    var getusername = prefs.getString('username');

    if (getusername != null) {
      // await Future.delayed(Duration(seconds: 1));
      setState(() {
        data = 'fetching data please wait...';
      });
    }
    Geolocator.checkPermission().then((value) async {
      if (value == LocationPermission.deniedForever) {
        await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Permision denied forever Please give it from application",
            selectionColor: Colors.red,
          ),
          backgroundColor: Colors.red,
        ));
        await Future.delayed(Duration(seconds: 2));
      } else if (value == LocationPermission.denied) {
        await Geolocator.requestPermission().then((value) async {
          if (value == LocationPermission.deniedForever) {
            await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Permision denied forever Please give it from application",
                selectionColor: Colors.red,
              ),
              backgroundColor: Colors.red,
            ));
            await Future.delayed(Duration(seconds: 2));
            exit(0);
          } else if (value == LocationPermission.denied) {
            await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Permision denied",
                selectionColor: Colors.red,
              ),
              backgroundColor: Colors.red,
            ));
            await Future.delayed(Duration(seconds: 2));
            exit(0);
          }
        });
      }
      Position? position;
      position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .onError((error, stackTrace) async {
        await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Permision denied",
            selectionColor: Colors.red,
          ),
          backgroundColor: Colors.red,
        ));
        await Future.delayed(Duration(seconds: 2));
        exit(0);
      });
      var prefs = await SharedPreferences.getInstance();
      var getusername = prefs.getString('username');

      if (getusername == null) {
        Navigator.popAndPushNamed(context, "/login");
      } else {
        DocumentSnapshot<Map<String, dynamic>>? doc = await FirebaseFirestore.instance.collection("Drivers").doc(getusername).get();
        print(doc.get('DrivingAllowed'));
        if(!doc.get('DrivingAllowed')){
          Navigator.popAndPushNamed(context, "/PermissinDenied");
        }
        else{
        Navigator.popAndPushNamed(context, "/home");
        }
      }
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Lottie.asset(
            "assets/Animation - 1708667354656.json",
          ),
        ),
        Lottie.asset(
            "assets/loadingDots.json",
          ),
        Text(data.toString())
      ],
    ));
  }
}
