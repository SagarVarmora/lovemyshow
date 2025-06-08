import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Wait for 3 seconds to show the splash screen
    await Future.delayed(const Duration(seconds: 3));

    // Check if a user is already logged in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is logged in, navigate to home
        Get.offAllNamed('/home');
      } else {
        // User is not logged in, navigate to sign-in
        Get.offAllNamed('/signin');
      }
    });
  }
}