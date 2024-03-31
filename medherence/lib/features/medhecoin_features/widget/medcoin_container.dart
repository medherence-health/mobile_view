import 'package:flutter/material.dart';

import '../../../core/constants_utils/color_utils.dart';

class MedcoinWidget extends StatelessWidget {

   MedcoinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.medMidgradient,
          ),
        ),
        Container(
          // Set the width of the container
          height: 130, // Set the height of the container
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
                left: 20.0, right: 20.0, top: 20, bottom: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Medhecoin Balance',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                const Text(
                  '00,000.00',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount in Naira',
                        style: TextStyle(
                          color: Color.fromARGB(255, 231, 177, 177),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          decorationColor: AppColors.white,
                          decoration: TextDecoration
                              .underline, // Add underline decoration
                        ),
                      ),
                      // Spacer(),
                      Image.asset(
                        'assets/images/coin.png',
                        height: 35,
                        width: 30,
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
