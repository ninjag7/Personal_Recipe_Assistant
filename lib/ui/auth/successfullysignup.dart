import 'dart:async';

import 'package:flutter/material.dart';

import 'login.dart';

class Created extends StatefulWidget {
  const Created({Key? key}) : super(key: key);

  @override
  State<Created> createState() => _CreatedState();
}

class _CreatedState extends State<Created> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const Login())); // Add semicolon (;) at the end
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              child: const Icon(Icons.check_circle),
            ),
          ],
        ),
      ),
    );
  }
}
