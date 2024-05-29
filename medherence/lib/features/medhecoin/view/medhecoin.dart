import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medherence/core/utils/size_manager.dart';
import 'package:medherence/features/dashboard_feature/view/dashboard_view.dart';
import 'package:medherence/features/more_features/withdrawal/view/withdrawal_view.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/shared_widget/buttons.dart';
import '../../home/widget/medecoin_widget.dart';
import '../../monitor/view_model/reminder_view_model.dart';
import '../../more_features/withdrawal/view/add_account_view.dart';
import '../view_model/medhecoin_wallet_view_model.dart';
import '../widget/med_wallet_pin_widget.dart';
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
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const DashboardView()),
                (Route<dynamic> route) => false);
            // Navigator.pop(context);
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
                  MaterialPageRoute(builder: (context) => const MedWalletPin()),
                );
              },
              child: const Icon(
                CupertinoIcons.gear_alt_fill,
                color: AppColors.pillIconColor,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<WalletViewModel>(
        builder: (context, model, _) => Padding(
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
                          text: const TextSpan(
                            text: 'Progress:',
                            style: TextStyle(
                              fontSize: (5),
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                            children: [
                              TextSpan(
                                text: ' 0',
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
                        const SizedBox(width: 50),
                        RichText(
                          text: const TextSpan(
                            text: 'Withdrawal Chances:',
                            style: TextStyle(
                              fontSize: (5),
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                            children: [
                              TextSpan(
                                text: ' 0',
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
                        buttonConfig: ButtonConfig(
                          text: 'Withdraw',
                          action: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) =>
                                    const MedhecoinWithdrawalView()),
                              ),
                            );
                            // Navigator.pop(context);
                          },
                          disabled: false,
                        ),
                        width: MediaQuery.of(context).size.width / 2,
                        // icon: const Icon(Icons.account_balance_wallet_outlined,
                        //     color: AppColors.mainPrimaryButton),
                        child: Image.asset(
                          'assets/images/withdrawal_icon.png',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: OutlinePrimaryButton(
                        textSize: 18,
                        icon: (Icons.add),
                        buttonConfig: ButtonConfig(
                          text: 'Add Account',
                          action: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const AddAccountView()),
                              ),
                            );
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
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: SizeMg.height(10),
                    bottom: SizeMg.height(16),
                  ),
                  itemBuilder: (ctx, index) => MedhecoinWalletHistory(
                      model: model.walletModelList[index]),
                  separatorBuilder: (ctx, index) => SizedBox(
                    height: SizeMg.height(10),
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
        ),
      ),
    );
  }
}
