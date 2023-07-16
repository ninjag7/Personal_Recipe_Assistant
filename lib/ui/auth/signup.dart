import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personalrecipeassistant1/google_signin/Authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/HomePage.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  String? nameError;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cnfpasswordController = TextEditingController();
  bool passwordVisible = false;
  String passwordStrength = '';

  void _showPasswordMismatchToast() {
    if (mounted) {
      Fluttertoast.showToast(
        msg: 'The password mismatch',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    }
  }

  String _checkPasswordStrength(String value) {
    if (value.isEmpty) {
      return '';
    } else if (value.length < 8) {
      return 'Weak';
    } else {
      return 'Strong';
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    });
  }

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // User is successfully registered, you can add additional logic here if needed

      // Show success dialog or perform other actions
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Success'),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('User registered successfully!'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CountdownWidget(countdownSeconds: 4),
                ],
              ),
            ],
          ),
        ),
      );
      // Get.to(()=>HomePage(username: "awais",email: "awais@gmail.com",));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      // Handle other Firebase Auth exceptions here
    } catch (e) {
      print(e.toString());
      // Handle other exceptions here
    }
  }

  bool _isEmailValid(String value) {
    return RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffE94240),
      // Background color same as login's body
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'Lato',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: TextFormField(
                      controller: nameController,
                      // onChanged: (value) {
                      //   setState(() async {
                      //     if (value.isEmpty) {
                      //       nameError = 'Full Name is required';
                      //     } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      //       nameError = 'Full Name must contain alphabets only';
                      //     } else {
                      //       SharedPreferences prefs =
                      //           await SharedPreferences.getInstance();
                      //       prefs.setString("username", value.toString());
                      //       var username = prefs.getString("username");
                      //       print(username.toString());
                      //       nameError = null;
                      //     }
                      //   });
                      // },
                      onChanged: (value) async {
                        // Asynchronous operations
                        if (value.isEmpty) {
                          setState(() {
                            nameError = 'Full Name is required';
                          });
                        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          setState(() {
                            nameError = 'Full Name must contain alphabets only';
                          });
                        } else {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString("username", value.toString());
                          var username = prefs.getString("username");
                          print(username.toString());
                          setState(() {
                            nameError = null;
                          });
                        }
                      },

                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        prefixIcon: const Icon(Icons.person),
                        errorText: nameError,
                        errorStyle: const TextStyle(
                            color: Colors.white), // Add this line
                      ),
                    ),
                  ),
                ),
              ),
              if (nameError != null)
                Container(
                  padding: const EdgeInsets.only(left: 30, top: 5),
                  child: Text(
                    nameError!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Email',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      onChanged: (value) {
                        setState(() {
                          passwordStrength = _checkPasswordStrength(value);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: TextFormField(
                      controller: cnfpasswordController,
                      obscureText: !passwordVisible,
                      onChanged: (value) {
                        setState(() {
                          passwordStrength = _checkPasswordStrength(value);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (passwordStrength.isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(left: 30, top: 10),
                  child: Text(
                    passwordStrength,
                    style: TextStyle(
                      backgroundColor: Colors.white,
                      color: passwordStrength == 'Weak'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ),
              Center(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (passwordController.text !=
                              cnfpasswordController.text) {
                            _showPasswordMismatchToast();
                          } else if (_isEmailValid(emailController.text)) {
                            await _signUpWithEmailAndPassword();
                            Get.to(() => HomePage(manualLogin: true));
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xffD8D83F),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(
                            const Size.fromHeight(50),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: const Text(
                          'Or',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 80,
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            User? user = await Authenticationn.signInWithGoogle(
                                context: context);
                            var name = user!.displayName;

                            if (user != null) {
                              Get.to(() => HomePage(
                                  username: name.toString(),
                                  email: user.email));
                            } else {
                              print("Inavelid credentials");
                            }
                          },
                          icon: SvgPicture.asset(
                            'images/icons8-google.svg',
                            // Replace with the path to your Google icon SVG file
                            width: 30,
                            height: 30,
                          ),
                          label: const Text(
                            'Signup with Google',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all(
                                const Size.fromHeight(40)),
                          ),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have any account?"),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                  print("signup clicked");
                                },
                                child: const Text(
                                  'Signin',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountdownWidget extends StatefulWidget {
  final int countdownSeconds;

  const CountdownWidget({super.key, required this.countdownSeconds});

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  int secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    setState(() {
      secondsRemaining = widget.countdownSeconds;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$secondsRemaining seconds',
      style: const TextStyle(fontSize: 20),
    );
  }
}
