import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/shared_widget/buttons.dart';
import '../widget/otp_tile.dart';

class VerifyForgotPassword extends StatefulWidget {
  String email;
  VerifyForgotPassword({required this.email, super.key});

  @override
  State<VerifyForgotPassword> createState() => _VerifyForgotPasswordState();
}

class _VerifyForgotPasswordState extends State<VerifyForgotPassword> {
  late final List<TextEditingController> _otpControllers;
  int _resendTimer = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(4, (index) => TextEditingController());
    startResendTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  bool get isFormValid {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 100,
        ),
        child: Center(
          child: ListView(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.textFilledColor.withOpacity(0.5),
                radius: 51,
                child: const CircleAvatar(
                  backgroundColor: AppColors.textFilledColor,
                  radius: 45,
                  child: Icon(
                    Icons.mark_email_unread_outlined,
                    size: 30,
                    color: AppColors.navBarColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Check your mail!',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'We sent a 4-digit code to',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade600,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${widget.email}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 8.0),
                child: SizedBox(
                  height: 120,
                  width: MediaQuery.of(context).size.width - 15,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _otpControllers.map((controller) {
                        _otpControllers.indexOf(controller);
                        return Row(
                          children: [
                            OtpTile(
                              otpSaved: () {},
                              numberController: controller,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(11.0, 8.0, 6.0, 8.0),
                child: PrimaryButton(
                  width: double.infinity,
                  buttonConfig: ButtonConfig(
                    text: 'Verify',
                    action: () async {},
                    // disabled: !isFormValid || viewModel.isBusy,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: 'Didn’t receive the email? ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade600,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend($_resendTimer)',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: AppColors.navBarColor,
                        ),
                      )
                    ]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
