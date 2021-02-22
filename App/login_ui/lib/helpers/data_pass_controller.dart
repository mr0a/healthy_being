import 'package:flutter/material.dart';

class MyController {
  static final TextEditingController dataController = TextEditingController();
  static final TextEditingController passController = TextEditingController();

  static String get username => dataController.text;
  static String get password => passController.text;

  static showError(BuildContext context, String error) {
    SnackBar snackBar = SnackBar(content: Text(error));
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
