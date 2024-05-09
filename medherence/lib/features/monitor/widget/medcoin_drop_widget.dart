import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/core/utils/color_utils.dart';

import '../../../../core/utils/size_manager.dart';
import '../../dashboard_feature/view/dashboard_view.dart';

class MedCoinDropWidget extends StatelessWidget {
  const MedCoinDropWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
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
      content: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20,
          bottom: 20,
        ),
        child: Container(
          child: Column(
            children: [
              Image.asset(
                'assets/images/coin_drop.png',
                height: SizeMg.height(100),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                    text: 'You have earned ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '100',
                        style: TextStyle(
                          color: AppColors.navBarColor,
                        ),
                      ),
                      TextSpan(
                        text: ' Medhecoin',
                      ),
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: OutlinePrimaryButton(
                  width: 200,
                  buttonConfig: ButtonConfig(
                    text: 'Yaayy!!!',
                    action: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DashboardView()),
                      );
                      // Navigator.pop(context);
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
