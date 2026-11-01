import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showNotification(
    BuildContext context, String title, String msg, ContentType ct) {
  final currentContext = context;

  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: msg,
      contentType: ct,
    ),
  );

  ScaffoldMessenger.of(currentContext)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showMessage(String message, String type) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: type.contains('error') ? Colors.red : Colors.grey[800],
    textColor: type.contains('error') ? Colors.yellow : Colors.white,
    fontSize: 20.0,
  );
}
