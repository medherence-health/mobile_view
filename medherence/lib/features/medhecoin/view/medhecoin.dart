import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medherence/core/utils/size_manager.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/shared_widget/buttons.dart';
import '../../home/widget/medecoin_widget.dart';
import '../../monitor/view_model/reminder_view_model.dart';
import '../../more_features/wallet/view/wallet_pin_view.dart';
import '../view_model/medhecoin_wallet_view_model.dart';
import '../widget/medcoin_wallet_history.dart';

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
    ReminderState reminderState = Provider.of<ReminderState>(context);

    int medcoinBalance = reminderState.medcoin;
    double medcoinInNaira = reminderState.medcoinInNaira;

    String coinTitle = _amountChanged ? 'Amount in Naira' : 'Amount in MDHC';
    String amount = _amountChanged
        ? medcoinInNaira.toStringAsFixed(2)
        : medcoinBalance.toString();

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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WalletPinView()),
                  );
                },
                child: Icon(
                  CupertinoIcons.gear_alt_fill,
                  color: AppColors.pillIconColor,
                ),
              ),
            ),
          ],
        ),
        body: ViewModelBuilder<WalletViewModel>.reactive(
            viewModelBuilder: () => WalletViewModel(),
            builder: (_, model, __) => Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25,
                    bottom: 10,
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MedhecoinWidget(
                          onTap: toggleAmountChanged,
                          iconData: null,
                          onPressed: null,
                          amountChanged: _amountChanged,
                          coinTitle: coinTitle,
                          amount: amount,
                        ),
                        const SizedBox(height: 15),
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              right: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Progress:',
                                    style: TextStyle(
                                      fontSize: (5),
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '15',
                                        style: TextStyle(
                                          fontSize: (6),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '/30',
                                        style: TextStyle(
                                          fontSize: (5),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 50),
                                RichText(
                                  text: TextSpan(
                                    text: 'Withdrawal Chances:',
                                    style: TextStyle(
                                      fontSize: (5),
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '2',
                                        style: TextStyle(
                                          fontSize: (6),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinePrimaryButton(
                                textSize: 18,
                                icon: const Icon(
                                    Icons.account_balance_wallet_outlined,
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
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) => MedhecoinWalletHistory(
                              model: model.walletModelList[index]),
                          separatorBuilder: (ctx, index) => SizedBox(
                            height: SizeMg.height(16),
                          ),
                          itemCount: model.walletModelList.length,
                        ),
                        if (model.walletModelList.isEmpty)
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
                  ),
                )));
  }
}
