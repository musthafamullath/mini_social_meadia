import 'package:flutter/material.dart';
import 'package:mechine_task_cumin360/views/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logoutUserController(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('password');
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }