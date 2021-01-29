import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qolsys_app/constants/color_constants.dart';

showToast(String msg, Color backgroundColor) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: kWhite,
      fontSize: 18.0);
}

cancelToast() {
  Fluttertoast.cancel();
}

successToast(String msg) {
  showToast(msg, kGreen);
}

errorToast(String msg) {
  showToast(msg, kRed);
}
