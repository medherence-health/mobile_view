import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/core/utils/color_utils.dart';

import '../../../../core/utils/size_manager.dart';
import '../../dashboard_feature/view/dashboard_view.dart';

class MedCoinDropWidget extends StatelessWidget {
  final int medhecoinEarned;

  const MedCoinDropWidget({Key? key, required this.medhecoinEarned})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Well-done Champ!!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      content: SizedBox(
        height: SizeMg.height(300),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
          ),
          child: Column(
            children: [
              Image.asset(
                'assets/images/coin_drop.png',
                height: SizeMg.height(200),
                width: SizeMg.width(250),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                    text: 'You have earned ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.darkGrey,
                    ),
                    children: [
                      TextSpan(
                        text: '$medhecoinEarned',
                        style: TextStyle(
                          color: AppColors.navBarColor,
                        ),
                      ),
                      TextSpan(
                        text: ' Medhecoin',
                      ),
                    ]),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomCenter,
                child: OutlinePrimaryButton(
                  width: 200,
                  textSize: SizeMg.text(16),
                  buttonConfig: ButtonConfig(
                    text: 'Yaayy!!!',
                    action: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => DashboardView()),
                          (Route<dynamic> route) => false);
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
