import 'package:flutter/material.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/shared_widget/buttons.dart';
import '../../home_feature/widget/medecoin_widget.dart';
import '../widget/medcoin_container.dart';

class MedhecoinScreen extends StatefulWidget {
  const MedhecoinScreen({super.key});

  @override
  State<MedhecoinScreen> createState() => _MedhecoinScreenState();
}

class _MedhecoinScreenState extends State<MedhecoinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Medhecoin',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          },icon:Icon(Icons.arrow_back_ios_new),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            children: [
              MedcoinWidget(),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinePrimaryButton(
                      textSize: 20,
                      icon: Icon(Icons.account_balance_wallet_outlined,
                          color: AppColors.mainPrimaryButton),
                      buttonConfig: ButtonConfig(
                        text: 'Withdraw',
                        action: () {
                          // Navigator.pop(context);
                        },
                        disabled: true,
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OutlinePrimaryButton(
                      textSize: 20,
                      icon: Icon(Icons.add, color: AppColors.mainPrimaryButton),
                      buttonConfig: ButtonConfig(
                        text: 'Add Account',
                        action: () {
                          // Navigator.pop(context);
                        },
                        disabled: true,
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text('History',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  )),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 170),
                  child: SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          color: AppColors.noWidgetText,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'You have no transaction history',
                          style: TextStyle(
                            fontSize: (16),
                            fontStyle: FontStyle.italic,
                            color: AppColors.noWidgetText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [],
              )
            ],
          ),
        ));
  }
}
