import 'package:flutter/material.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/features/auth/views/forgot_password.dart';
import 'package:medherence/features/auth/widget/validation_extension.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/constants/constants.dart';
import '../widget/textfield.dart';
import '../../dashboard_feature/view/dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController hospitalNumberController;
  late TextEditingController passwordController;
  String? _selectedHospital;
  bool obscurePassword = false;
  bool _rememberMe = false;
  Color emailFillColor = Colors.white70;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hospitalNumberController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
          right: 25,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Enter your login details to access the app',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Hospital/Clinical Name',
                style: TextStyle(
                  fontSize: (18),
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: (10)),
              TextFormField(
                controller:
                    TextEditingController(text: _selectedHospital ?? ''),
                enabled: true, // Disable editing directly in the field
                readOnly: true,
                decoration: InputDecoration(
                  // ... apply desired styling here
                  hintStyle: kFormTextDecoration.hintStyle,
                  filled: false,
                  fillColor: kFormTextDecoration.fillColor,
                  errorBorder: kFormTextDecoration.errorBorder,
                  border: kFormTextDecoration.border,
                  focusedBorder: kFormTextDecoration.focusedBorder,
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      setState(() {
                        _selectedHospital = value;
                      });
                    },
                    itemBuilder: (context) => _buildDropdownItems(),
                  ),
                  hintText: "Select your HCP",
                ),
              ),
              const SizedBox(height: (20)),
              TitleAndTextFormField(
                title: 'Hospital Number',
                formFieldHint: 'Please type your Hospital Number',
                formFieldController: hospitalNumberController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                formFieldColor: emailFillColor,
                formFieldValidator: (value) {
                  return null;
                },
              ),
              const SizedBox(
                height: (20),
              ),
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: (18),
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: (10),
              ),
              TextFormField(
                obscureText: !obscurePassword,
                controller: passwordController,
                cursorHeight: 19,
                decoration: InputDecoration(
                  hintStyle: kFormTextDecoration.hintStyle,
                  filled: false,
                  fillColor: kFormTextDecoration.fillColor,
                  errorBorder: kFormTextDecoration.errorBorder,
                  border: kFormTextDecoration.border,
                  focusedBorder: kFormTextDecoration.focusedBorder,
                  hintText: "Type in your password",
                  suffixIcon: IconButton(
                      icon: obscurePassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.remove_red_eye_rounded),
                      iconSize: 24,
                      onPressed: () => setState(() {
                            obscurePassword = !obscurePassword;
                          })),
                ),
                validator: (value) => value!.validatePassword(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  const Text(
                    'Remember Me',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()));
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.navBarColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                width: double.infinity,
                buttonConfig: ButtonConfig(
                  text: 'Sign In',
                  action: () {
                    if (_formKey.currentState!.validate()) {
                      // Password change logic goes here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Password changed successfully')),
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const DashboardView()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          dismissDirection: DismissDirection.horizontal,
                          elevation: 10,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(15),
                          content: Text(
                              'Oops, you have inputted the wrong login details.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  disabled: (_selectedHospital == '' ||
                      passwordController.text.isEmpty ||
                      hospitalNumberController.text.isEmpty),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.feedback_rounded,
                      color: Colors.blue.shade200,
                    ),
                  ),
                  Flexible(
                    child: RichText(
                      text: const TextSpan(
                        text: 'You don\'t have a Medherence account? ',
                        style: TextStyle(
                          letterSpacing: 0.3,
                          fontStyle: FontStyle.italic,
                          color: AppColors.darkGrey,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Reach out to your Healthcare Provider to enroll you on the platform',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.3,
                                color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PopupMenuItem<String>> _buildDropdownItems() {
    List<String> hospitalNames = [
      'Hospital A',
      'Hospital B',
      'Hospital C',
      'Hospital D',
      'Hospital E',
      'Hospital F',
      'Hospital G',
      'Hospital H',
      'Hospital I',
      'Hospital J',
    ];
    return hospitalNames.map((String value) {
      return PopupMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }
}
