import 'package:flutter/material.dart';

import '../../../core/utils/size_manager.dart';
import '../wallet/widget/wallet_pin_widget.dart';

class BiometricAuthenticationView extends StatefulWidget {
  const BiometricAuthenticationView({Key? key}) : super(key: key);

  @override
  _BiometricAuthenticationViewState createState() =>
      _BiometricAuthenticationViewState();
}

class _BiometricAuthenticationViewState
    extends State<BiometricAuthenticationView> {
  bool _isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Biometric Authentication',
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
      body: Padding(
        padding: EdgeInsets.only(left: 25, right: 25, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enhance Your Wallet Security: Enable biometric authentication to Safeguard Your Earnings and Transactions',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text(
                'Enable Fingerprint',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: _isBiometricEnabled,
              onChanged: (value) {
                setState(() {
                  _isBiometricEnabled = value;
                  if (_isBiometricEnabled) {
                    _showWalletPinDialog();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showWalletPinDialog() {
    showDialog(
      context: context,
      builder: (context) => WalletPinWidget(),
    );
  }
}
