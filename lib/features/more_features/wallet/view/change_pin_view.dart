import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/core/database/database_service.dart';
import 'package:medherence/features/auth/widget/validation_extension.dart';
import 'package:medherence/features/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/shared_widget/buttons.dart';
import '../../../../core/utils/size_manager.dart';

class ChangeWalletPinView extends StatefulWidget {
  const ChangeWalletPinView({super.key});

  @override
  State<ChangeWalletPinView> createState() => _ChangeWalletPinViewState();
}

class _ChangeWalletPinViewState extends State<ChangeWalletPinView> {
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmNewPinController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureOldPin = true;
  bool _obscureNewPin = true;
  bool _obscureConfirmNewPin = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<SecurityResult> _fetchSecurityData() {
    return context.watch<ProfileViewModel>().getSecurity();
  }

  void navigateBackToHome() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet pin changed successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SecurityResult>(
      future: _fetchSecurityData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Failed to load data"));
        }

        bool hideOldPin = snapshot.data!.security?.pin == "0000";

        return Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enhance Your Wallet Security: Change Your PIN to Safeguard Your Earnings and Transactions.',
                ),
                const SizedBox(height: 15),
                if (!hideOldPin)
                  _buildPinInputField(
                    'Old Wallet Pin',
                    _oldPinController,
                    _obscureOldPin,
                    () => setState(() => _obscureOldPin = !_obscureOldPin),
                  ),
                SizedBox(height: SizeMg.height(16)),
                _buildPinInputField(
                  'New Wallet Pin',
                  _newPinController,
                  _obscureNewPin,
                  () => setState(() => _obscureNewPin = !_obscureNewPin),
                ),
                SizedBox(height: SizeMg.height(16)),
                _buildPinInputField(
                  'Confirm New Wallet Pin',
                  _confirmNewPinController,
                  _obscureConfirmNewPin,
                  () => setState(
                      () => _obscureConfirmNewPin = !_obscureConfirmNewPin),
                ),
                if (_errorMessage != null) ...[
                  SizedBox(height: SizeMg.height(10)),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(height: SizeMg.height(40)),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        buttonConfig: ButtonConfig(
                          text: 'Save Pin',
                          action: () => savePin(context, snapshot.data!),
                          disabled: false,
                        ),
                        width: double.infinity,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPinInputField(String label, TextEditingController controller,
      bool obscureText, VoidCallback onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: SizeMg.text(18), color: Colors.black),
        ),
        SizedBox(height: SizeMg.height(5)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintStyle: kFormTextDecoration.hintStyle,
            filled: false,
            fillColor: kFormTextDecoration.fillColor,
            errorBorder: kFormTextDecoration.errorBorder,
            border: kFormTextDecoration.border,
            focusedBorder: kFormTextDecoration.focusedBorder,
            hintText: "Enter your pin",
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              iconSize: SizeMg.radius(24),
              onPressed: onToggle,
            ),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          validator: (value) {
            if (label.contains("Confirm") && value != _newPinController.text) {
              return 'Pins do not match.';
            }
            return value!.validatePin();
          },
        ),
      ],
    );
  }

  Future<void> savePin(
      BuildContext context, SecurityResult securityResult) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String oldPin = _oldPinController.text;
    String newPin = _newPinController.text;
    String confirmNewPin = _confirmNewPinController.text;

    if (newPin != confirmNewPin) {
      setState(() {
        _isLoading = false;
        _errorMessage = "New PIN and Confirm PIN must match.";
      });
      return;
    }

    try {
      if (securityResult.security?.pin == "0000" ||
          securityResult.security?.pin == oldPin) {
        var security = securityResult.security;
        security!.pin = newPin;
        await context.read<ProfileViewModel>().updatePin(security);
        navigateBackToHome();
      } else if (newPin == oldPin) {
        setState(
            () => _errorMessage = "You cannot use the old PIN as the new PIN.");
      } else {
        setState(() => _errorMessage = "Invalid old PIN.");
      }
    } catch (e) {
      setState(() => _errorMessage = "An error occurred. Please try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
