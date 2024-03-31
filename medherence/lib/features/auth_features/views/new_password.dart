import 'package:flutter/material.dart';
import 'package:medherence/features/auth_features/widget/validation_extension.dart';
import 'package:medherence/features/dashboard_feature/view/dashboard.dart';
import 'package:medherence/features/home_feature/view/home_view.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/constants_utils/constants.dart';
import '../../../core/shared_widget/buttons.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: SizedBox(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    textScaleFactor: 1.15,
                    text: TextSpan(
                        text:
                            '* Use a combination of uppercase and lowercase letters. \n',
                            style: TextStyle(color: AppColors.black, fontSize: 15,),
                        children: [
                          TextSpan(
                            text: '* Include at least one number (0-9).\n',
                          ),
                          TextSpan(
                            text:
                                '*  Include at least one special character (e.g., !, @, #, \$, %, ^, &, *). \n',
                          ),
                          TextSpan(
                            text:
                                '* Avoid using easily guessable information, such as your name, username, or common words. \n',
                          ),
                          TextSpan(
                              text:
                                  '* Aim for a minimum length of 8 characters, but longer passwords are generally more secure.'),
                        ]),
                  ),
                  SizedBox(height: 40),
                  const Text(
                'Old Password',
                style: TextStyle(
                  fontSize: (18),
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: (10),
              ),
                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: _obscureOldPassword,
                    decoration: InputDecoration(
                      // labelText: 'Old Password',
                      hintStyle: kFormTextDecoration.hintStyle,
                      filled: false,
                      fillColor: kFormTextDecoration.fillColor,
                      errorBorder: kFormTextDecoration.errorBorder,
                      border: kFormTextDecoration.border,
                      focusedBorder: kFormTextDecoration.focusedBorder,
                      hintText: "Type in your password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureOldPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        iconSize: 24,
                        onPressed: () {
                          setState(() {
                            _obscureOldPassword = !_obscureOldPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Input your old password.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  const Text(
                'New Password',
                style: TextStyle(
                  fontSize: (18),
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: (10),
              ),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      // labelText: 'New Password',
                      hintStyle: kFormTextDecoration.hintStyle,
                      filled: false,
                      fillColor: kFormTextDecoration.fillColor,
                      errorBorder: kFormTextDecoration.errorBorder,
                      border: kFormTextDecoration.border,
                      focusedBorder: kFormTextDecoration.focusedBorder,
                      hintText: "Type in your password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        iconSize: 24,
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      return value!.validatePassword();
                    },
                  ),
                  SizedBox(height: 16),
                  const Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: (18),
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: (10),
              ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      // labelText: 'Confirm Password',
                      hintStyle: kFormTextDecoration.hintStyle,
                      filled: false,
                      fillColor: kFormTextDecoration.fillColor,
                      errorBorder: kFormTextDecoration.errorBorder,
                      border: kFormTextDecoration.border,
                      focusedBorder: kFormTextDecoration.focusedBorder,
                      hintText: "Type in your password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        iconSize: 24,
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  PrimaryButton(
                    buttonConfig: ButtonConfig(
                      text: 'Save Password',
                      action: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardView(),
                            ),
                          );
                        if (_formKey.currentState!.validate()) {
                          // Password change logic goes here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Password changed successfully')),
                          );
                        }
                      },
                      disabled: false,
                    ),
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
