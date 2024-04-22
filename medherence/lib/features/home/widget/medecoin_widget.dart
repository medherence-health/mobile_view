import 'package:flutter/material.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';

class MedhecoinWidget extends StatelessWidget {
  final Icon? icon;
  bool amountChanged;
  final VoidCallback? onPressed;
  VoidCallback onTap;

  MedhecoinWidget(
    this.onTap,
    this.icon,
    this.onPressed,
    this.amountChanged, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String coinTitle = 'Amount in Naira';
    String amount = '000 MDHC';
    String naira = '\u20a6';
    if (amountChanged == true) {
      coinTitle = 'Amount in medcoin';
      amount = '$naira 000.00 ';
    }
    return Stack(
      children: [
        Container(
          height: SizeMg.height(120),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              SizeMg.radius(15),
            ),
            color: AppColors.medMidgradient,
          ),
        ),
        Container(
          // Set the width of the container
          height: SizeMg.height(120), // Set the height of the container
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              SizeMg.radius(15),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft, // Start the gradient from the left
              end: Alignment.centerRight, // End the gradient to the right
              colors: [
                AppColors.mainPrimaryButton.withOpacity(0.6),
                AppColors.disabledButton.withOpacity(0.6),
              ], // Define the colors for the gradient
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 6, bottom: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Medhecoin Balance',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: SizeMg.text(16),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    IconButton(
                      onPressed: onPressed,
                      icon: icon!,
                      color: AppColors.white,
                    ),
                  ],
                ),
                Text(
                  amount,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeMg.text(32),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: onTap,
                        child: Text(
                          coinTitle,
                          style: TextStyle(
                            color: AppColors.staleWhite,
                            fontSize: SizeMg.text(16),
                            fontWeight: FontWeight.w400,
                            decorationColor: AppColors.white,
                            decoration: TextDecoration
                                .underline, // Add underline decoration
                          ),
                        ),
                      ),
                      // Spacer(),
                      Image.asset(
                        'assets/images/coin.png',
                        height: SizeMg.height(35),
                        width: SizeMg.width(30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
