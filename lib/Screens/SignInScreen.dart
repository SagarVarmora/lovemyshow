import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:lovemyshow/Controller/AuthController.dart';
import 'package:lovemyshow/Widgets/GradientBackground.dart';
import 'package:lovemyshow/Widgets/LoveMyShowLogo.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: LoveMyShowLogo(
                              width: 300,
                              height: 80,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: _buildSignInSection(controller),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom > 0
                                ? 20
                                : 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Sign in',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        _buildPhoneInput(controller),
        const SizedBox(height: 30),
        _buildSignInButton(controller),
      ],
    );
  }

  Widget _buildPhoneInput(AuthController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CountryCodePicker(
            onChanged: (countryCode) {
              controller.setCountryCode(countryCode.dialCode ?? '+91');
            },
            initialSelection: 'IN',
            favorite: ['+91', 'IN'],
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
            textStyle: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: Colors.grey[400],
          ),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Enter mobile number',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
              onSubmitted: (_) {
                if (!controller.isLoading.value) {
                  controller.signIn();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton(AuthController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.signIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE91E63),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: const Color(0xFFE91E63).withOpacity(0.3),
          disabledBackgroundColor: const Color(0xFFE91E63).withOpacity(0.6),
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
              'SIGN IN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
      )),
    );
  }
}