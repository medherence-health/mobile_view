import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medherence/core/utils/size_manager.dart';

import '../../../../core/shared_widget/buttons.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../dashboard_feature/view/dashboard_view.dart';

class SuccessfulTransaction extends StatelessWidget {
  final String amount;
  const SuccessfulTransaction({required this.amount, super.key});

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
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/transaction check.png',
                    width: SizeMg.width(60),
                    height: SizeMg.height(60),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'You have successfully withdrawn',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: SizeMg.text(14),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  '$amount MDHC',
                  style: TextStyle(
                    color: AppColors.navBarColor,
                    fontSize: SizeMg.text(22),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              child: PrimaryButton(
                buttonConfig: ButtonConfig(
                    text: 'Go to Dashboard',
                    action: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => DashboardView(),
                          ),
                          (route) => false);
                    }),
                width: SizeMg.screenWidth - 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
