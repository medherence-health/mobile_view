import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/core/constants/constants.dart';

class OtpTile extends StatelessWidget {
  final dynamic otpSaved;
  final TextEditingController numberController;
  const OtpTile({
    required this.otpSaved,
    required this.numberController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 70,
      child: TextFormField(
        controller: numberController,
        //cursorColor: Colors.black,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
        //onSaved: otpSaved,
        decoration: InputDecoration(
          filled: false,
          enabled: true,
          focusedBorder: kFormTextDecoration.focusedBorder,
          enabledBorder: kFormTextDecoration.enabledBorder,
          fillColor: kFormTextDecoration.fillColor,
          hintText: '0',
          hintStyle: kFormTextDecoration.hintStyle,
          border: kFormTextDecoration.border,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
