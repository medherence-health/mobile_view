import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return CupertinoAlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
          child: Column(
            children: [
              Text(
                'Enter your Wallet Pin to enable fingerprint',
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: SizeMg.width(200),
                  height: SizeMg.height(50),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => Flexible(child: _buildPinTextField(index)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinTextField(int index) {
    return Container(
      width: SizeMg.width(28),
      height: SizeMg.height(28),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _controllers[index].text.isNotEmpty
            ? AppColors.historyBackground
            : Colors.grey,
        shape: BoxShape.circle,
      ),
      child: CupertinoTextField(
        controller: _controllers[index],
        focusNode: index == 3 ? _lastFocusNode : null,
        obscureText: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.isEmpty) {
            // If the field is empty, move to the previous field
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          } else if (value.length == 1) {
            // If a digit is entered, move to the next field
            FocusScope.of(context).nextFocus();
          }
          if (index == 3) {
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
