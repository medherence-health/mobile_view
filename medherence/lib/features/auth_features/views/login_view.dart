import 'package:flutter/material.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/features/auth_features/widget/validation_extension.dart';

import '../../../core/constants_utils/constants.dart';
import '../widget/textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController hospitalNumberController;
  late TextEditingController passwordController;
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
            fontSize: 26,
            fontWeight: FontWeight.w600,
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
              TitleAndTextFormField(
                title: 'Hospital Number',
                formFieldHint: 'Please type your E-mail',
                formFieldController: hospitalNumberController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                formFieldColor: emailFillColor,
                formFieldValidator: (value) {
                  return value!.emailValidation();
                },
              ),
              const Text(
                'Hospital/Clinical Name',
                style: TextStyle(
                  fontSize: (18),
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: (10)),
              DropdownButtonFormField<dynamic>(
                // value: _selectedRegionId,
                onChanged: (newValue) {},
                items: _buildDropdownItems(),
                decoration: kProfileInputDecoration,
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
                  suffixIcon: IconButton(
                      icon: obscurePassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.remove_red_eye_rounded),
                      iconSize: 24,
                      onPressed: () => setState(() {
                            obscurePassword = !obscurePassword;
                          })),
                  border: kFormTextDecoration.border,
                  hintText: "Type in your password",
                ),
                validator: (value) => value!.validatePassword(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                buttonConfig: ButtonConfig(
                  text: 'Sign In',
                  action: () {
                    _buildCompleteProfile();
                  },
                  disabled: false,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.info,
                      color: Colors.blue.shade200,
                    ),
                  ),
                  const Flexible(
                    child: Text(
                        'You don\'t have a Medherence account? Reach out to your Healthcare Provider to enrol you on the platform',
                        style: TextStyle(
                          letterSpacing: 0.6,
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<dynamic>>? _buildDropdownItems() {
    return null;
  }

  _buildCompleteProfile() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            (15),
          ),
        ),
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Complete Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(
            height: (20),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
            ),
            child: Text(
              'To unlock the full potential of the Medherence app, you are to complete your user profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (18),
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15,
            ),
            child: PrimaryButton(
              buttonConfig: ButtonConfig(
                text: 'Complete Profile',
                action: () {
                  Navigator.pop(context);
                },
                disabled: false,
              ),
            ),
          ),
        ],
      ),
    );
    await Future.delayed(
      const Duration(
        seconds: 5,
      ),
    );
  }
}
