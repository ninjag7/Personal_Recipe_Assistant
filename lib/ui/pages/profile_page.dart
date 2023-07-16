import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;

  const ProfilePage({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Name: $name',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Text(
            'Email: $email',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
