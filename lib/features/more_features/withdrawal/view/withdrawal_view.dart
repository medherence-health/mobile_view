import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/features/medhecoin/view_model/medhecoin_wallet_view_model.dart';
import 'package:medherence/features/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/shared_widget/buttons.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/size_manager.dart';
import '../../../../core/utils/utils.dart';
import '../../../monitor/view_model/reminder_view_model.dart';
import '../widget/confirmation_widget.dart';

/// View for initiating Medhecoin withdrawal, including form and confirmation.
class MedhecoinWithdrawalView extends StatefulWidget {
  const MedhecoinWithdrawalView({super.key});

  @override
  State<MedhecoinWithdrawalView> createState() =>
      _MedhecoinWithdrawalViewState();
}

class _MedhecoinWithdrawalViewState extends State<MedhecoinWithdrawalView> {
  late TextEditingController _accountNumberController;
  late TextEditingController _amountController;
  final TextEditingController _dropDownSearchController =
      TextEditingController();
  Color? amountFillColor = Colors.white70;
  Color? accountFillColor = Colors.white70;
  bool showConfirmation = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _accountNumberController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _accountNumberController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    final availableMedcoin =
        Provider.of<ReminderState>(context, listen: false).medcoin;
    final equivalentMedcoin =
        Provider.of<ReminderState>(context, listen: false).medcoinInNaira;
    return Consumer<WalletViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            showConfirmation == true ? 'Confirmation' : 'Withdrawal',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              if (showConfirmation) {
                setState(() {
                  showConfirmation = false; // Return to withdrawal view
                });
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.navBarColor),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: showConfirmation == true
              ? buildConfirmWithdrawal(model)
              : buildWithdrawalForm(model, availableMedcoin),
        ),
      ),
    );
  }

  /// Builds the withdrawal form UI.
  Widget buildWithdrawalForm(WalletViewModel model, int? availableMedcoin) {
    return FutureBuilder<void>(
      future: context.watch<ProfileViewModel>().getPatientTodayDrugs(
          auth.currentUser?.uid ?? ""), // Assume this fetches necessary data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: model.savedAccountModelList.isNotEmpty,
                        child: SizedBox(
                          height: SizeMg.height(130),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Saved Accounts',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: SizeMg.text(14),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Flexible(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    final item =
                                        model.savedAccountModelList[index];
                                    return Column(
                                      children: [
                                        CircleAvatar(
                                          radius: SizeMg.radius(25),
                                          child: Image.asset(
                                            item.src,
                                            width: 55,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Flexible(
                                          child: SizedBox(
                                            width: SizeMg.width(60),
                                            child: Text(
                                              item.accountName ?? 'ADB',
                                              style: TextStyle(
                                                fontSize: SizeMg.text(12),
                                                color: AppColors.darkGrey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (ctx, index) => SizedBox(
                                    height: SizeMg.width(15),
                                  ),
                                  itemCount: model.savedAccountModelList.length,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Additional form fields here...
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: checkOutContainer(
                  balance: availableMedcoin!,
                  model: model,
                  amount: model.amount?.toStringAsFixed(2) ?? '-----',
                  transferFee: model.amount != null
                      ? model.transferFee.toStringAsFixed(2)
                      : '---',
                  totalAmount: model.totalAmount?.toStringAsFixed(2) ?? '-----',
                ),
              ),
            ],
          );
        }
      },
    );
  }

  /// Builds the confirmation UI for withdrawal.
  Widget buildConfirmWithdrawal(WalletViewModel model) {
    return ConfirmWithdrawal(
      amount: model.amount?.toStringAsFixed(2) ?? '-----',
      transferFee: model.transferFee.toStringAsFixed(2),
      totalAmount: model.totalAmount?.toStringAsFixed(2) ?? '-----',
      receiverName: model.accountOwnerName ??
          'Joe Stephens ${_accountNumberController.text.trim()}',
      bankName: model.selectedBank ?? '',
      amountEquivalence: model.amountInNaira.toStringAsFixed(2),
      dateTime: StringUtils.checkToday(DateTime.now()),
    );
  }

  /// Widget for displaying checkout details.
  Widget checkOutContainer({
    WalletViewModel? model,
    required String amount,
    required String transferFee,
    required String totalAmount,
    required int balance,
  }) {
    return Container(
      child: Column(
        children: [
          const Divider(color: AppColors.historyBackground),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: SizeMg.text(14),
                      ),
                    ),
                    const SizedBox(),
                    RichText(
                      text: TextSpan(
                        text: '$amount MDHC',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeMg.text(16),
                          color: AppColors.blackGreen,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transfer fee',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: SizeMg.text(14),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '$transferFee MDHC',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeMg.text(16),
                          color: AppColors.blackGreen,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TotalAmount',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: SizeMg.text(14),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '$totalAmount MDHC',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeMg.text(16),
                          color: AppColors.blackGreen,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  buttonConfig: ButtonConfig(
                    text: 'Checkout',
                    action: () {
                      String? validationError =
                          model?.validateWithdrawal(balance);
                      if (validationError == null &&
                          model?.amountError == null &&
                          _formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account verified'),
                          ),
                        );
                        Provider.of<WalletViewModel>(context, listen: false)
                            .calculateTotalAmount();
                        setState(() {
                          showConfirmation = true;
                        });
                      } else if (validationError != null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Error',
                              style: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: SizeMg.text(18),
                              ),
                            ),
                            content: Text(
                              validationError != null
                                  ? validationError.toString()
                                  : 'Something went wrong',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: SizeMg.text(14),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  width: SizeMg.screenWidth,
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
