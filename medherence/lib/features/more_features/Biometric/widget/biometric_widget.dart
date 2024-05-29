import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/model/models/wallet_model.dart';
import '../../../../core/service/biometric_service.dart';
import '../../../../core/shared_widget/buttons.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/size_manager.dart';
import '../../../medhecoin/view_model/medhecoin_wallet_view_model.dart';
import '../../../monitor/view_model/reminder_view_model.dart';
import '../../../profile/view_model/profile_view_model.dart';
import '../../withdrawal/widget/transaction_successful_widget.dart';

class BiometricWidget extends StatefulWidget {
  const BiometricWidget({super.key});

  @override
  State<BiometricWidget> createState() => _BiometricWidgetState();
}

class _BiometricWidgetState extends State<BiometricWidget> {
  final BiometricService _biometricService = BiometricService();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10.withOpacity(0.6),
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    if (mounted) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return confirmBiometric();
                          });
                    }
                  },
                  child: SizedBox(
                    child: Image.asset('assets/images/fingerprint_sensor.png',
                        width: 50, height: 50),
                  ),
                ),
              ),
              Text(
                'Use Fingerprint',
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeMg.text(14),
                ),
              ),
              // if (_isLoading) LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget confirmBiometric() {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Confirm Transaction',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      content: FittedBox(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  bool isAuthenticated = await _biometricService.authenticate();
                  if (isAuthenticated) {
                    Navigator.pop(
                        context); // Close the dialog if authentication is successful
                    // Proceed with your action after successful biometric authentication
                    setState(() {
                      _isLoading = true;
                    });
                    _showLoadingAndNavigate(context);
                  } else {
                    // Handle failed authentication
                  }
                },
                child: Image.asset(
                  'assets/images/fingerprint_sensor.png',
                  height: SizeMg.height(60),
                  width: SizeMg.width(60),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Touch the fingerprint sensor',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.bottomCenter,
                child: OutlinePrimaryButton(
                  width: 200,
                  textSize: SizeMg.text(16),
                  buttonConfig: ButtonConfig(
                    text: 'Cancel',
                    action: () {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoadingAndNavigate(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Column(children: [
          if (_isLoading == true)
            LinearProgressIndicator(
              color: AppColors.navBarColor,
              backgroundColor: AppColors.disabledButton,
            ),
        ]);
      },
    );

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
      // double? totalAmount =
      //     Provider.of<WalletViewModel>(context, listen: false).totalAmount;
      final walletViewModel =
          Provider.of<WalletViewModel>(context, listen: false);
      final profile = Provider.of<ProfileViewModel>(context, listen: false);
      final monitor = Provider.of<ReminderState>(context, listen: false);
      // Create a new transaction model
      final newTransaction = WalletModel(
        firstName: profile.nickName.isNotEmpty
            ? profile.nickName
            : 'ADB', // Replace with actual data
        lastName: '', // Replace with actual data
        src:
            'assets/images/bank_logo/medherence_icon.png', // Replace with actual data
        title: 'Withdrawal',
        dateTime: DateTime.now().toString(), // Use the current date and time
        price: walletViewModel.totalAmount!.toDouble(),
        debit: true,
      );

      // Add the new transaction to the wallet model list
      Provider.of<WalletViewModel>(context, listen: false)
          .addTransaction(newTransaction);

      // walletViewModel.addTransaction(newTransaction);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => SuccessfulTransaction(
                  amount: walletViewModel.totalAmount?.toStringAsFixed(2)
                      as String)),
          (Route<dynamic> route) => false);
      monitor.deductMedcoin(walletViewModel.totalAmount!.toInt());
      debugPrint(walletViewModel.totalAmount.toString());
    });
  }
}
