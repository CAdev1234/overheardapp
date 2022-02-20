// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';

void showToast(String msg, Color color, {ToastGravity gravity = ToastGravity.BOTTOM}){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

SnackBar getSnackBar(BuildContext context, String message){
  return SnackBar(
    content: Text(
      message,
      textScaleFactor: 1.0,
      style: const TextStyle(
        fontSize: primaryButtonMiddleFontSize,
        color: primaryWhiteTextColor,
      ),
    ),
    action: SnackBarAction(
      label: OkbuttonText,
      onPressed: (){
        // Scaffold.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).removeCurrentSnackBar(
          reason: SnackBarClosedReason.timeout
        );
      },
    ),
  );
}