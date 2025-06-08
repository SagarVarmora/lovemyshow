import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final RxString otp = ''.obs;
  final RxBool isLoading = false.obs;
  final RxInt resendTimer = 60.obs;
  final RxBool canResend = false.obs;

  late String phoneNumber;
  late String verificationId;
  int? resendToken;
  Timer? _timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    phoneNumber = args?['phoneNumber'] ?? '';
    verificationId = args?['verificationId'] ?? '';
    resendToken = args?['resendToken'];

    startResendTimer();

    otpController.addListener(() {
      otp.value = otpController.text;
    });
  }

  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 60;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    if (canResend.value) {
      isLoading.value = true;
      final formattedPhoneNumber = '+91$phoneNumber';

      _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        forceResendingToken: resendToken,
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
        codeSent: (String newVerificationId, int? newResendToken) {
          isLoading.value = false;
          verificationId = newVerificationId;
          resendToken = newResendToken;

          Get.snackbar(
            'OTP Sent',
            'Verification code has been sent again',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            margin: EdgeInsets.all(16),
          );
          startResendTimer();
        },
        codeAutoRetrievalTimeout: (String newVerificationId) {},
        timeout: const Duration(seconds: 60),
      );
    }
  }

  void verifyOtp() {
    if (otpController.text.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter complete OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text,
      );

      _handleCredential(credential);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Invalid OTP. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
      );
    }
  }

  void _handleCredential(PhoneAuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential);
      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Phone number verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
      );

      Get.offAllNamed('/country');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Verification failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
      );
    }
  }

  String get formattedPhoneNumber {
    if (phoneNumber.length >= 10) {
      return '+91 ${phoneNumber.substring(0, 5)} ${phoneNumber.substring(5)}';
    }
    return '+91 $phoneNumber';
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}