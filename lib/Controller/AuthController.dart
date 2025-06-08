import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString phoneNumber = ''.obs;
  final RxString countryCode = '+91'.obs; // Default to +91
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(() {
      phoneNumber.value = phoneController.text;
    });
  }

  void setCountryCode(String code) {
    countryCode.value = code;
  }

  void signIn() {
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
      );
      return;
    }

    if (phoneController.text.length < 10) {
      Get.snackbar(
        'Error',
        'Please enter a valid mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    final formattedPhoneNumber = '${countryCode.value}${phoneController.text}';

    _auth.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        _handleCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          e.message ?? 'Verification failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        isLoading.value = false;
        Get.toNamed('/otp', arguments: {
          'phoneNumber': phoneController.text,
          'verificationId': verificationId,
          'resendToken': resendToken,
          'countryCode': countryCode.value,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  void _handleCredential(PhoneAuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential);
      isLoading.value = false;
      Get.offAllNamed('/home');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Authentication failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
      );
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}