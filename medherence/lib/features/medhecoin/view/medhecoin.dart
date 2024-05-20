import 'package:flutter/material.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/shared_widget/buttons.dart';
import '../../home/widget/medecoin_widget.dart';
import '../widget/medcoin_container.dart';

class MedhecoinScreen extends StatefulWidget {
  const MedhecoinScreen({super.key});

  @override
  State<MedhecoinScreen> createState() => _MedhecoinScreenState();
}

class _MedhecoinScreenState extends State<MedhecoinScreen> {
  bool _amountChanged = false; // Add this variable

  // Function to toggle the amount changed
  void toggleAmountChanged() {
    setState(() {
      _amountChanged = !_amountChanged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Medhecoin',
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
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25,
            bottom: 10,
          ),
          child: ListView(
            children: [
              MedhecoinWidget(
                () {
                  setState(() {
                    // Call the function to toggle the amount changed
                    toggleAmountChanged();
                  });
                },
                null,
                null,
                _amountChanged,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinePrimaryButton(
                      textSize: 18,
                      icon: const Icon(Icons.account_balance_wallet_outlined,
                          color: AppColors.mainPrimaryButton),
                      buttonConfig: ButtonConfig(
                        text: 'Withdraw',
                        action: () {
                          // Navigator.pop(context);
                        },
                        disabled: false,
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OutlinePrimaryButton(
                      textSize: 18,
                      icon: const Icon(Icons.add,
                          color: AppColors.mainPrimaryButton),
                      buttonConfig: ButtonConfig(
                        text: 'Add Account',
                        action: () {
                          // Navigator.pop(context);
                        },
                        disabled: false,
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text('History',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  )),
              const Center(
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
              const Column(
                children: [],
              )
            ],
          ),
        ));
  }
}
