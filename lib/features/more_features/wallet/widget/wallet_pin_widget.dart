import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/core/constants/constants.dart';
import 'package:medherence/core/model/models/transaction_model.dart';
import 'package:medherence/core/model/models/user_data.dart';
import 'package:medherence/features/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class WalletPinWidget extends StatefulWidget {
  final String amount;
  final String transferFee;
  final String totalAmount;
  final String receiverName;
  final String accountNumber;
  final String bankName;
  final String amountEquivalence;
  final String dateTime;
  const WalletPinWidget({
    Key? key,
    required this.amount,
    required this.transferFee,
    required this.totalAmount,
    required this.receiverName,
    required this.accountNumber,
    required this.bankName,
    required this.amountEquivalence,
    required this.dateTime,
  }) : super(key: key);

  @override
  _WalletPinWidgetState createState() => _WalletPinWidgetState();
}

class _WalletPinWidgetState extends State<WalletPinWidget> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<String> _errorNotifier = ValueNotifier<String>("");
  bool _isLoading = false; // Loading state

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _verifyPinAndCloseDialog(String currentPin, UserData? userData) async {
    var profileViewModel = context.read<ProfileViewModel>();
    final enteredPin = _controllers.map((c) => c.text).join();

    if (userData == null) {
      error("Invalid user data");
      return;
    }
    if (enteredPin != currentPin) {
      error("Invalid pin");
      return;
    }

    double amount;
    double transactionFees;

    try {
      amount = double.parse(widget.totalAmount);
      transactionFees = double.parse(widget.transferFee);
    } catch (e) {
      error("Invalid transaction amounts");
      return;
    }

    var transaction = TransactionModel(
      amount: amount,
      currency: "NGN",
      transactionDate: currentTimeInMilli.toString(),
      senderId: userData.userId,
      recipientId: userData.facilityId ?? "",
      patientId: userData.userId,
      hospitalId: userData.facilityId ?? "",
      adherenceStatus: "Good",
      paymentMethod: "bank",
      transactionStatus: "pending",
      transactionType: "debit",
      referenceNumber: "",
      fraudCheckIndicator: "",
      transactionFees: transactionFees,
      taxAmount: 0,
      netAmount: 0,
      platformChannel: "app",
      ipAddress: "",
      deviceId: "",
      bankName: widget.bankName,
      bankAccountName: widget.receiverName,
      bankAccountNumber: widget.accountNumber,
    );

    setState(() {
      _isLoading = true; // Show loading
    });

    var res = await profileViewModel.withdrawal(transaction, userData);

    setState(() {
      _isLoading = false; // Hide loading
    });

    if (res == ok) {
      Navigator.pop(context, true);
    } else {
      error(res);
    }
  }

  void error(String msg) {
    _errorNotifier.value = msg;
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNode.requestFocus();
  }

  Future<({String pin, UserData? userData})> _fetchCurrentPinAndUserData(
      BuildContext context) async {
    var profileViewModel = context.watch<ProfileViewModel>();

    var res = await profileViewModel.getSecurity();
    var resUserData = await profileViewModel.getUserData();

    return (pin: res.security?.pin ?? "aaaa", userData: resUserData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<({String pin, UserData? userData})>(
      future: _fetchCurrentPinAndUserData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Failed to load PIN"));
        }

        String currentPin = snapshot.data!.pin;
        UserData? userData = snapshot.data!.userData;

        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200,
              child: StatefulBuilder(
                builder: (context, setStateLocal) {
                  return Column(
                    children: [
                      const Text('Enter your Wallet Pin to enable fingerprint'),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const CircularProgressIndicator() // Show loading
                          : Container(
                              width: 200,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  4,
                                  (index) => Flexible(
                                    child: _buildPinTextField(index, currentPin,
                                        setStateLocal, userData),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 10),
                      ValueListenableBuilder<String>(
                        valueListenable: _errorNotifier,
                        builder: (context, value, child) {
                          if (value.isNotEmpty) {
                            return Text(
                              value,
                              style: const TextStyle(color: Colors.red),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPinTextField(int index, String currentPin,
      Function setStateLocal, UserData? userData) {
    return CupertinoTextField(
      controller: _controllers[index],
      focusNode: index == 0 ? _focusNode : null,
      obscureText: true,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide.none),
      ),
      enabled: !_isLoading, // Disable input while loading
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        if (value.isEmpty) {
          if (index > 0) FocusScope.of(context).previousFocus();
        } else if (value.length == 1 || index < 3) {
          FocusScope.of(context).nextFocus();
        }

        bool allFieldsFilled = _controllers.every((c) => c.text.isNotEmpty);

        if (index == 3 && allFieldsFilled) {
          _verifyPinAndCloseDialog(currentPin, userData);
        }

        setStateLocal(() {});
      },
    );
  }
}
