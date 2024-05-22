import 'package:flutter/material.dart';

import '../../../../core/utils/color_utils.dart';

class MedhecoinWithdrawalView extends StatelessWidget {
  const MedhecoinWithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Withdrawal',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.navBarColor),
        ),
      ),
    );
  }
}
