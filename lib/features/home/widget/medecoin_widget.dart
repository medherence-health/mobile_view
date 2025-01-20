import 'package:flutter/material.dart';
import 'package:medherence/core/model/models/user_data.dart';
import 'package:medherence/features/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';

class MedhecoinWidget extends StatelessWidget {
  final IconButton? iconData;
  final bool amountChanged;
  final VoidCallback? onPressed;
  final VoidCallback onTap;
  final String coinTitle;
  final String amount;
  final bool allowConversion;

  const MedhecoinWidget({
    required this.onTap,
    required this.iconData,
    required this.onPressed,
    required this.amountChanged,
    required this.coinTitle,
    required this.amount,
    required this.allowConversion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
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
                  left: 20.0, right: 10.0, top: 6, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Medhecoin Balance',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: SizeMg.text(14),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          child: iconData,
                        ),
                      ],
                    ),
                  ),
                  amountChanged == true
                      ? RichText(
                          text: TextSpan(
                            text: '\u{20A6}',
                            style: TextStyle(
                              fontSize: SizeMg.text(19),
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: amount,
                              ),
                            ],
                          ),
                        )
                      : CoinBalanceWidget(),
                  allowConversion
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: onTap,
                              child: Text(
                                coinTitle,
                                style: TextStyle(
                                  color: AppColors.staleWhite,
                                  fontSize: SizeMg.text(14),
                                  fontWeight: FontWeight.w400,
                                  decorationColor: AppColors.white,
                                  decoration: TextDecoration
                                      .underline, // Add underline decoration
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/coin.png',
                              height: SizeMg.height(30),
                              width: SizeMg.width(40),
                            ),
                          ],
                        )
                      : Row(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoinBalanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: context.watch<ProfileViewModel>().getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Safely access the data here
          final amount = snapshot.data?.medhecoinBalance ?? 0.0;
          print("medhecoinBalance: $amount");

          return RichText(
            text: TextSpan(
              text: amount.toStringAsFixed(2), // Format to 2 decimal places
              style: TextStyle(
                fontSize: SizeMg.text(22),
                color: Colors.white,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: ' MDHC',
                  style: TextStyle(
                    fontSize: SizeMg.text(19),
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        } else {
          return RichText(
            text: TextSpan(
              text: "0.00",
              style: TextStyle(
                fontSize: SizeMg.text(22),
                color: Colors.white,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: ' MDHC',
                  style: TextStyle(
                    fontSize: SizeMg.text(19),
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
