import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medherence/core/model/models/user_data.dart';
import 'package:medherence/features/auth/widget/validation_extension.dart';
import 'package:medherence/features/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/shared_widget/buttons.dart';
import '../../../../core/utils/size_manager.dart';
import 'change_pin_view.dart';

class WalletPinView extends StatefulWidget {
  const WalletPinView({super.key});

  @override
  State<WalletPinView> createState() => _WalletPinViewState();
}

class _WalletPinViewState extends State<WalletPinView> {
  final TextEditingController _passwordController = TextEditingController();
  bool _showChangePinView = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    Future<UserData?> _verificationFuture =
        context.watch<ProfileViewModel>().getUserData();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet Pin',
          style: TextStyle(
            fontSize: SizeMg.text(25),
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins-bold.ttf",
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: FutureBuilder<UserData?>(
        future: _verificationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (_showChangePinView) {
            return const ChangeWalletPinView();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Enter your account password to verify that it is you'),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintStyle: kFormTextDecoration.hintStyle,
                      filled: false,
                      fillColor: kFormTextDecoration.fillColor,
                      errorBorder: kFormTextDecoration.errorBorder,
                      border: kFormTextDecoration.border,
                      focusedBorder: kFormTextDecoration.focusedBorder,
                      hintText: "Type in your password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        iconSize: SizeMg.radius(24),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      return value!.validatePassword();
                    },
                  ),
                  SizedBox(height: SizeMg.height(30)),
                  PrimaryButton(
                    width: double.infinity,
                    buttonConfig: ButtonConfig(
                      text: _isLoading ? 'Verifying...' : 'Verify',
                      action: _isLoading
                          ? () {}
                          : () {
                              setState(() {
                                _isLoading = true;
                                _errorMessage = null; // Clear previous error
                              });
                              verifyPassword(snapshot.data?.email ?? "",
                                      _passwordController.text)
                                  .then((result) {
                                setState(() {
                                  _isLoading = false;
                                  if (result != "ok") {
                                    _errorMessage = result;
                                  }
                                });
                              });
                            },
                      disabled: _isLoading,
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String> verifyPassword(String email, String password) async {
    print("Verifying: $email , $password");
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() {
        _showChangePinView = true;
      });

      return "ok";
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that email.';
      }
      return errorMessage;
    }
  }
}
