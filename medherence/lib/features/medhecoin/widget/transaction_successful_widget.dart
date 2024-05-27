import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medherence/core/utils/size_manager.dart';

import '../../../core/utils/color_utils.dart';

class SuccessfulTransaction extends StatelessWidget {
  const SuccessfulTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction Successful',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Center(
              child: Image.asset(
                'assets/images/transaction failure.png',
                width: SizeMg.width(60),
                height: SizeMg.height(60),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'We\'re sorry, the transaction could not be processed at this time try again',
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: SizeMg.text(14),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
