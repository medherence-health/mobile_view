import 'package:flutter/material.dart';
import 'package:medherence/core/utils/color_utils.dart';

import '../../../../core/utils/size_manager.dart';

class WalletPinWidget extends StatefulWidget {
  const WalletPinWidget({Key? key}) : super(key: key);

  @override
  _WalletPinWidgetState createState() => _WalletPinWidgetState();
}

class _WalletPinWidgetState extends State<WalletPinWidget> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final FocusNode _lastFocusNode = FocusNode();

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.historyBackground,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Enter your Wallet Pin to enable fingerprint'),
            SizedBox(height: 16),
            Container(
              width: SizeMg.width(200),
              height: SizeMg.height(50),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: _buildPinTextField(index),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinTextField(int index) {
    return Container(
      width: SizeMg.width(36),
      height: SizeMg.height(36),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            _controllers[index].text.isNotEmpty ? AppColors.white : Colors.grey,
        shape: BoxShape.circle,
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: index == 3 ? _lastFocusNode : null,
        obscureText: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (index == 3 && value.length == 1) {
            // Last digit entered, perform verification
            _verifyPinAndCloseDialog();
          }
        },
      ),
    );
  }

  void _verifyPinAndCloseDialog() {
    final enteredPin = _controllers.map((controller) => controller.text).join();
    // Perform pin verification here
    print('Entered PIN: $enteredPin');
    Navigator.pop(context); // Close the dialog
  }
}
