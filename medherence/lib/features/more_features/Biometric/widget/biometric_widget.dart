import 'package:flutter/material.dart';

import '../../../../core/service/biometric_service.dart';
import '../../../../core/shared_widget/buttons.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/size_manager.dart';

class BiometricWidget extends StatefulWidget {
  const BiometricWidget({super.key});

  @override
  State<BiometricWidget> createState() => _BiometricWidgetState();
}

class _BiometricWidgetState extends State<BiometricWidget> {
  final BiometricService _biometricService = BiometricService();
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
                    LinearProgressIndicator();
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
}
