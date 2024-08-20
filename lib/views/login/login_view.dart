import 'package:flutter/material.dart';
import 'package:mechine_task_cumin360/views/login/widgets/check_if_signed_up.dart';
import 'package:mechine_task_cumin360/views/home/home_view.dart';
import 'package:mechine_task_cumin360/views/signup/signup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mechine_task_cumin360/sources/constants/colors.dart';
import 'package:mechine_task_cumin360/sources/constants/widgets.dart';
import 'package:mechine_task_cumin360/widgets/button_widget.dart';
import 'package:mechine_task_cumin360/widgets/snackbar_function.dart';
import 'package:mechine_task_cumin360/widgets/text_field_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String _loginStatus = '';

  @override
  void initState() {
    super.initState();
    checkIfSignedUp(context);
  }


 void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }




 

  void _login(
    
  ) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _loginStatus = '';
      });

      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedEmail = prefs.getString('email');
      String? storedPassword = prefs.getString('password');

    
      await Future.delayed(const Duration(seconds: 2));

    
      if (storedEmail == userController.text &&
          storedPassword == passwordController.text) {
        setState(() {
          _isLoading = false;
          _loginStatus = 'success';
        });

        
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainViews()),
        );
        // ignore: use_build_context_synchronously
        showSnack(context, green, "Successfully logged in");
      } else {
        setState(() {
          _isLoading = false;
          _loginStatus = 'failed';
        });
        
        // ignore: use_build_context_synchronously
        showSnack(context, red, "Invalid email or password");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: yellow,
        title: const Text('Login Page',style: TextStyle(
          fontSize: 24,fontWeight: FontWeight.w700
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Card(
            child: Container(
              
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  kHight30,
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Login to your account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  kHight30,
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFieldWidget(
                          userController: userController,
                          label: 'Email-address:',
                          inputType: TextInputType.emailAddress,
                          obscureText: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your email address";
                            }
                            return null;
                          },
                        ),
                        kHight10,
                        TextFieldWidget(
                          userController: passwordController,
                          label: 'Password:',
                          inputType: TextInputType.name,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                        ),
                        kHight30,
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ButtonWidget(
                                width: size * 6 / 10,
                                text: 'Login',
                                onPressed: _login,
                                height: size * 2.7 / 10,
                              ),
                        if (_loginStatus == 'failed')
                          const Text(
                            'Login failed. Please try again.',
                            style: TextStyle(color: red),
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SignupView()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(
                        color: black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  kHight30,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
