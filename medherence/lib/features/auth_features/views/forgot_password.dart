import 'package:flutter/material.dart';
import 'package:medherence/features/auth_features/widget/validation_extension.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/shared_widget/buttons.dart';
import '../widget/textfield.dart';
import 'verify_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailController;
  Color emailFillColor = Colors.white70;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 100,
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.textFilledColor.withOpacity(0.5),
                    radius: 51,
                    child: const CircleAvatar(
                      backgroundColor: AppColors.textFilledColor,
                      radius: 45,
                      child: Icon(
                        Icons.vertical_split_outlined,
                        size: 30,
                        color: AppColors.navBarColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Text(
                      'Don\'t worry! Please enter your associated E-mail address, we would send you reset instructions.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TitleAndTextFormField(
                    title: 'E-mail',
                    formFieldHint: 'Please type your associated E-mail',
                    formFieldController: emailController,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                    formFieldColor: emailFillColor,
                    formFieldValidator: (value) {
                      return value!.emailValidation();
                    },
                  ),
                  const SizedBox(height: 35),
                  PrimaryButton(
                    buttonConfig: ButtonConfig(
                      text: 'Send',
                      action: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyForgotPassword(
                              email: emailController.text,
                            ),
                          ),
                        );
                      },
                      disabled: false,
                    ),
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
