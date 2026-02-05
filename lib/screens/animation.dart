// import 'package:admin/Login/View/Verify_Otp.dart';
// import 'package:admin/Login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:driver/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:admin/Login/variables.dart';

class animation extends StatefulWidget {
  const animation({super.key});

  @override
  State<animation> createState() => _LoginState();
}

class _LoginState extends State<animation> {
  TextEditingController Username = TextEditingController();
  TextEditingController Password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset("assets/animation2.json",
            repeat: true,
            reverse: true,
            ),
            
          )
        ],
      )
    );
    }
    }