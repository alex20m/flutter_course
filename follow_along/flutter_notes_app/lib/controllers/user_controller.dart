import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var user = Rx<User?>(FirebaseAuth.instance.currentUser);

  loginAnonymously() async {
    final credentials = await FirebaseAuth.instance.signInAnonymously();
    user.value = credentials.user;
  }
}