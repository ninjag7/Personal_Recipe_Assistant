import 'package:firebase_auth/firebase_auth.dart';
import 'package:personalrecipeassistant1/ui/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../google_signin/Authentication.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = false;
  bool hidePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  void loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  void saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      prefs.setString('email', emailController.text.trim());
      prefs.setString('password', passwordController.text.trim());
      prefs.setBool('rememberMe', rememberMe);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.setBool('rememberMe', rememberMe);
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      // Save user details
      saveUserDetails();
      User user = userCredential.user!;
      await user.reload(); // Refresh the user data to get the display name
      user = FirebaseAuth.instance.currentUser!; // G
      // et the updated user object
      print(user.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString("username");
      // Navigate to the home page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            username: user.displayName ?? "",
            email: user.email,
            prefName: username,
            manualLogin: true,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("Login failed: $e");
      if (e.code == 'invalid-email') {
        setState(() {
          emailError = 'Please enter a valid email';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          passwordError = 'Password is incorrect';
        });
      }
    }
  }

  Future<bool> signUpWithEmailAndPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("username");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      // Save user details
      saveUserDetails();

      // Navigate to the home page
      Get.to(HomePage(
        username: userCredential.user?.displayName,
        email: userCredential.user?.email,
        prefName: username.toString(),
      ));
      return true;
    } on FirebaseAuthException catch (e) {
      print("Sign up failed: $e");
      if (e.code == 'weak-password') {
        setState(() {
          passwordError = 'Password is too weak';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          emailError = 'Email is already in use';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          emailError = 'Please enter a valid email';
        });
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffE94240),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Lato',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your Email',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        prefixIcon: const Icon(Icons.person),
                        errorText: emailError,
                        errorStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                        errorText: passwordError,
                        errorStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 80),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 300,
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: signInWithEmailAndPassword,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffD8D83f)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                    minimumSize:
                        MaterialStateProperty.all(const Size.fromHeight(50)),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: const Text(
                  'Or',
                  style: TextStyle(fontSize: 25, color: Colors.white),
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
                            email: user.email.toString(),
                          ));
                    } else {
                      print("Inavelid credentials");
                    }

                    //      print("google sign tapped");
                  },
                  icon: SvgPicture.asset(
                    'images/icons8-google.svg',
                    width: 30,
                    height: 30,
                  ),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                    minimumSize:
                        MaterialStateProperty.all(const Size.fromHeight(40)),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                          print("signup clicked");
                        },
                        child: const Text(
                          'Signup',
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
    );
  }
}
