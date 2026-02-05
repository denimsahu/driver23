import 'package:flutter/material.dart';

Widget CustomBigElevatedButton({
  required BuildContext context,
  required Function onPressed,
  String? text,
  Widget? child,
  Color? color,
}

) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      height: 50.0,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: text!=null?Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ):
            child,
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
            backgroundColor: MaterialStatePropertyAll(color??Colors.red[400])),
));
}