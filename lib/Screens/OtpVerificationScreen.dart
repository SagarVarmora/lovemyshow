import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lovemyshow/Controller/OtpController.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OtpController controller = Get.find<OtpController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 24.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(controller),
                      const SizedBox(height: 50),
                      _buildOtpInput(controller),
                      const SizedBox(height: 40),
                      _buildContinueButton(controller),
                      const SizedBox(height: 30),
                      _buildResendSection(controller),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom > 0
                            ? 20
                            : 100,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(OtpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'We\'ve send you the verification\ncode on ${controller.formattedPhoneNumber}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput(OtpController controller) {
    return PinCodeTextField(
      appContext: Get.context!,
      length: 6,
      controller: controller.otpController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 50,
        fieldWidth: 45,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        activeColor: const Color(0xFFE91E63),
        inactiveColor: Colors.grey[300]!,
        selectedColor: const Color(0xFFE91E63),
        borderWidth: 2,
      ),
      enableActiveFill: true,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      onChanged: (value) {
        controller.otp.value = value;
      },
      onCompleted: (value) {
        if (value.length == 6) {
          controller.verifyOtp();
        }
      },
      beforeTextPaste: (text) {
        if (text == null) return false;
        return text.contains(RegExp(r'^[0-9]+$'));
      },
    );
  }

  Widget _buildContinueButton(OtpController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.verifyOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE91E63),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CONTINUE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildResendSection(OtpController controller) {
    return Center(
      child: Obx(() => GestureDetector(
        onTap: controller.canResend.value ? controller.resendOtp : null,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Re - send code in ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              TextSpan(
                text: controller.canResend.value
                    ? 'Resend now'
                    : '0:${controller.resendTimer.value.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 16,
                  color: controller.canResend.value
                      ? const Color(0xFFE91E63)
                      : Colors.grey[600],
                  fontWeight: controller.canResend.value
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}