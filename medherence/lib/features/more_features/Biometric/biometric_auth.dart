import 'package:flutter/material.dart';
import 'package:medherence/core/utils/color_utils.dart';

import '../../../core/utils/size_manager.dart';
import '../wallet/widget/wallet_pin_widget.dart';

// class BiometricAuthenticationView extends StatefulWidget {
//   const BiometricAuthenticationView({Key? key}) : super(key: key);

//   @override
//   _BiometricAuthenticationViewState createState() =>
//       _BiometricAuthenticationViewState();
// }

// class _BiometricAuthenticationViewState
//     extends State<BiometricAuthenticationView> {
//   bool _isBiometricEnabled = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Biometric Authentication',
//           style: TextStyle(
//             fontSize: SizeMg.text(25),
//             fontWeight: FontWeight.w600,
//             fontFamily: "Poppins-bold.ttf",
//           ),
//           textAlign: TextAlign.center,
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios_new),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Enhance Your Wallet Security: Enable biometric authentication to Safeguard Your Earnings and Transactions',
//               style: TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 20),
//             SwitchListTile(
//               title: const Text(
//                 'Enable Fingerprint',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               value: _isBiometricEnabled,
//               onChanged: (value) {
//                 setState(() {
//                   _isBiometricEnabled = value;
//                   if (_isBiometricEnabled) {
//                     _showWalletPinDialog();
//                   }
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showWalletPinDialog() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) => const WalletPinWidget(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    super.initState();
    _loadBiometricEnabledState();
  }

  Future<void> _loadBiometricEnabledState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isBiometricEnabled = prefs.getBool('useBiometric') ?? false;
    setState(() {});
  }

  Future<void> _saveBiometricEnabledState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useBiometric', value);
  }

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
        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enhance Your Wallet Security: Enable biometric authentication to Safeguard Your Earnings and Transactions',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              activeColor: AppColors.success,
              title: const Text(
                'Enable Fingerprint',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: _isBiometricEnabled,
              onChanged: (value) async {
                setState(() {
                  _isBiometricEnabled = value;
                  _saveBiometricEnabledState(value);
                });
                if (_isBiometricEnabled) {
                  await _showWalletPinDialog(); // Wait for pin confirmation
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showWalletPinDialog() async {
    final confirmed = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const WalletPinWidget(),
    );
    if (confirmed != null && confirmed) {
      // User confirmed PIN, enable biometric authentication
      // Your logic for enabling biometric authentication here
      setState(() {
        _isBiometricEnabled = true;
        _saveBiometricEnabledState(true);
      });
    } else {
      // User canceled or failed PIN verification, disable switch
      setState(() {
        _isBiometricEnabled = false;
        _saveBiometricEnabledState(false);
      });
    }
  }
}
