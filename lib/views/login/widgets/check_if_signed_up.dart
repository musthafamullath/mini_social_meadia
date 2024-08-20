import 'package:flutter/material.dart';
import 'package:mechine_task_cumin360/views/home/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void checkIfSignedUp(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isSignedUp = prefs.getBool('isSignedUp') ?? false;

  if (isSignedUp) {
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainViews()),
    );
  }
}
