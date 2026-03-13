import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/note_controller.dart';
import 'controllers/user_controller.dart';
import 'screens/login_screen.dart';
import 'screens/note_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.lazyPut<NoteController>(
    () => NoteController(),
  );
  Get.lazyPut<UserController>(
    () => UserController(),
  );

  runApp(
    GetMaterialApp(
      title: 'My notes',
      home: NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (userController.user.value == null) {
          return LoginScreen();
        } else {
          return NoteScreen();
        }
      },
    );
  }
}