 import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUserController(
      String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }