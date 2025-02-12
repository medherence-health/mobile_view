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
  final String bankName;
  final String amountEquivalence;
  final String dateTime;
  const WalletPinWidget({
    Key? key,
    required this.amount,
    required this.transferFee,
    required this.totalAmount,
    required this.receiverName,
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

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  Future<String> _fetchCurrentPin(BuildContext context) async {
    var res = await context.watch<ProfileViewModel>().getSecurity();
    return res.security?.pin ?? "aaaa";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchCurrentPin(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Failed to load PIN"));
        }

        String currentPin = snapshot.data!;

        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200,
              child: StatefulBuilder(
                builder: (context, setStateLocal) {
                  String validationMessage = "";

                  return Column(
                    children: [
                      const Text('Enter your Wallet Pin to enable fingerprint'),
                      const SizedBox(height: 16),
                      Container(
                        width: 200,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => Flexible(
                              child: _buildPinTextField(
                                index,
                                currentPin,
                                setStateLocal,
                              ),
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

  final ValueNotifier<String> _errorNotifier = ValueNotifier<String>("");

  Widget _buildPinTextField(
      int index, String currentPin, Function setStateLocal) {
    return CupertinoTextField(
      controller: _controllers[index],
      focusNode: index == 0 ? _focusNode : null,
      obscureText: true,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide.none),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        bool allFieldsFilled = _controllers.every((c) => c.text.isNotEmpty);

        if (value.isEmpty) {
          if (index > 0) FocusScope.of(context).previousFocus();
        } else if (value.length == 1 || index < 3) {
          FocusScope.of(context).nextFocus();
        }

        if (index == 3 && allFieldsFilled) {
          _verifyPinAndCloseDialog(currentPin);
        }

        setStateLocal(() {});
      },
    );
  }

  void _verifyPinAndCloseDialog(String currentPin, UserData userData) {
    final enteredPin = _controllers.map((c) => c.text).join();
    var transaction = TransactionModel(
        amount: double.parse(widget.totalAmount),
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
        transactionFees: double.parse(widget.transferFee),
        taxAmount: 0,
        netAmount: 0,
        platformChannel: "app",
        ipAddress: "",
        deviceId: "");
    if (enteredPin == currentPin) {
      Navigator.pop(context, true);
    } else {
      _errorNotifier.value = "Incorrect PIN. Try again.";
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNode.requestFocus(); // Reset focus to the first field
    }
  }
}
