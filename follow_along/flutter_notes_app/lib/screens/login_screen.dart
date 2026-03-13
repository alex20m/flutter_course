import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Login anonymously'),
              onPressed: () => userController.loginAnonymously(),
            ),
          ],
        ),
      ),
    );
  }
}