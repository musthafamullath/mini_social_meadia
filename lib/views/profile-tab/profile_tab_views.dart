import 'package:flutter/material.dart';
import 'package:mechine_task_cumin360/controllers/user_controllers/logout_user_controller.dart';
import 'package:mechine_task_cumin360/sources/constants/colors.dart';
import 'package:mechine_task_cumin360/sources/constants/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileViews extends StatefulWidget {
  const ProfileViews({super.key});

  @override
  ProfileViewsState createState() => ProfileViewsState();
}

class ProfileViewsState extends State<ProfileViews> {
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'No name';
      _email = prefs.getString('email') ?? 'No email';
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await logoutUserController(context); // Call logout function
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile',
        style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24),),
        centerTitle: true,
        backgroundColor: yellow,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  kHight50,
                  const Text(
                    'User Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  kHight20,
                  Text('Name: $_name', style: const TextStyle(fontSize: 18)),
                  kHight20,
                  Text('Email: $_email', style: const TextStyle(fontSize: 18)),
                  kHight30,
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          _showLogoutDialog, // Show dialog on button press
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      child: const Text('Log Out'),
                    ),
                  ),
                  kHight50,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
