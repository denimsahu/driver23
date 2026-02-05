import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Permision_denied extends StatelessWidget {
  const Permision_denied({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Lottie.asset(
            "assets/Animation - 1708449965681.json",
          ),
        ),
        Text("you Can't Driver Contact with Admin",style: TextStyle(
          color: Colors.red,
          fontSize: 20.0
        ),),
      ],
    ));
  }
}