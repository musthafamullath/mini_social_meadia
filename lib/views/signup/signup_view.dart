import 'package:mechine_task_cumin360/controllers/user_controllers/store_user_controller.dart';
import 'package:mechine_task_cumin360/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:mechine_task_cumin360/sources/constants/colors.dart';
import 'package:mechine_task_cumin360/sources/constants/widgets.dart';
import 'package:mechine_task_cumin360/widgets/button_widget.dart';
import 'package:mechine_task_cumin360/widgets/snackbar_function.dart';
import 'package:mechine_task_cumin360/widgets/text_field_widget.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  String _registrationStatus = '';

  

  void _register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _registrationStatus = '';
      });

      await Future.delayed(const Duration(seconds: 2));

      bool registrationSuccess = true;

      if (registrationSuccess) {
        await storeUserController(
          nameController.text,
          emailController.text,
          passwordController.text,
        );

        setState(() {
          _isLoading = false;
          _registrationStatus = 'success';
        });

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginView()),
        );

        // ignore: use_build_context_synchronously
        showSnack(context, green, "Successfully signed up");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellow,
        title: const Text('SingUp Page',style: TextStyle(
          fontWeight: FontWeight.w700,fontSize: 24,
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Sign Up to your account",
                  style: TextStyle(fontSize: 18),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      kHight10,
                      TextFieldWidget(
                        userController: nameController,
                        label: 'Name:',
                        inputType: TextInputType.name,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      kHight10,
                      TextFieldWidget(
                        userController: emailController,
                        label: 'Email-address:',
                        inputType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      kHight10,
                      TextFieldWidget(
                        userController: passwordController,
                        label: 'Password:',
                        inputType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      kHight20,
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ButtonWidget(
                              width: size * 6 / 10,
                              height: size * 2.7 / 10,
                              text: 'Register',
                              onPressed: _register,
                            ),
                      if (_registrationStatus == 'failed')
                        const Text(
                          'Registration failed. Please try again.',
                          style: TextStyle(color: red),
                        ),
                    ],
                  ),
                ),
                kHight10,
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LoginView()),
                    );
                  },
                  child: const Text(
                    "Back to Login Page? Login",
                    style: TextStyle(
                      color: black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
