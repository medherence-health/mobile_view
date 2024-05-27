import 'dart:collection';
import 'package:flutter/material.dart';
import '../../../core/model/models/wallet_model.dart';

class WalletViewModel extends ChangeNotifier {
  String? selectedBank;
  String? accountOwnerName;
  double transferFee = 25.66;
  int? amount;
  double? totalAmount;
  String? amountError;
  List<String> bankNames = [
    'Access Bank',
    'Citibank',
    'Ecobank',
    'Fidelity Bank',
    'First Bank of Nigeria',
    'First City Monument Bank (FCMB)',
    'Guaranty Trust Bank (GTBank)',
    'Heritage Bank',
    'Keystone Bank',
    'Polaris Bank',
    'Providus Bank',
    'Stanbic IBTC Bank',
    'Standard Chartered Bank',
    'Sterling Bank',
    'Union Bank',
    'United Bank for Africa (UBA)',
    'Unity Bank',
    'Wema Bank',
    'Zenith Bank',
  ];

  List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(bankNames);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  final List<WalletModel> _walletModels = [
    WalletModel(
      firstName: 'Mark',
      lastName: 'Davids',
      src: 'assets/images/bank_logo/firstbank_logo.png',
      title: 'Withdrawal',
      dateTime: '20240418 19:20',
      price: 10000,
      debit: true,
    ),
    WalletModel(
      firstName: 'Rachael',
      lastName: 'Smith',
      src: 'assets/images/bank_logo/medherence_icon.png',
      title: 'Adherence Bonus',
      dateTime: '20240417 23:20',
      price: 15101,
      debit: false,
    ),
    WalletModel(
      firstName: 'Filo',
      lastName: 'Andre',
      src: 'assets/images/bank_logo/firstbank_logo.png',
      title: 'Withdrawal',
      dateTime: '20240410 14:43',
      price: 9567.77,
      debit: true,
    ),
    WalletModel(
      firstName: 'John',
      lastName: 'Pickel',
      src: 'assets/images/bank_logo/medherence_icon.png',
      title: 'Adherence Bonus',
      dateTime: '20240809 10:00',
      price: 9567.77,
      debit: false,
    ),
  ];
  String? validateWithdrawal(int? mainBalance) {
    if (totalAmount != null && totalAmount! > mainBalance!) {
      return 'Total amount exceeds your available balance.';
    }
    return null;
  }

  UnmodifiableListView<WalletModel> get walletModelList {
    _walletModels.sort((a, b) => DateTime.parse(b.dateTime)
        .millisecondsSinceEpoch
        .compareTo(DateTime.parse(a.dateTime).millisecondsSinceEpoch));
    return UnmodifiableListView(_walletModels);
  }

  // Method to validate account number
  Future<void> validateAccountNumber(String bank, String accountNumber) async {
    // Simulate an API call delay
    await Future.delayed(Duration(seconds: 2));

    // Mock response (in a real app, this would be a network call)
    if (bank == "Access Bank" && accountNumber == "1234567890") {
      accountOwnerName = "John Doe";
    } else {
      accountOwnerName =
          "Account number not found"; // Simulate invalid account or bank
    }
    notifyListeners();
  }

  // Method to check if the amount is within the allowed limit
  bool isAmountWithinLimit(int? amount, int? availableMedcoin) {
    return amount! <= availableMedcoin!;
  }

  // Method to update the amount and calculate the total amount
  void updateAmount(String value, int? availableMedcoin) {
    if (value.isNotEmpty) {
      amount = int.tryParse(value);
      if (amount != null && isAmountWithinLimit(amount, availableMedcoin)) {
        amountError = null;
        calculateTotalAmount();
      } else {
        amountError = "Amount exceeds available balance";
        amount = null;
        totalAmount = null;
      }
    } else {
      amount = null;
      totalAmount = null;
      amountError = null;
    }
    notifyListeners();
  }

  // Method to update the transfer fee
  void updateTransferFee(String value) {
    transferFee = double.tryParse(value) ?? 25.66;
    calculateTotalAmount();
    notifyListeners();
  }

  // Method to calculate the total amount
  void calculateTotalAmount() {
    if (amount != null) {
      totalAmount = amount! + transferFee;
    } else {
      totalAmount = null;
    }
  }

  double medcoinToNairaRate = 0.1; // 1 Medcoin = 0.1 Naira

  double get amountInNaira {
    if (totalAmount != null) {
      return totalAmount! * medcoinToNairaRate;
    }
    return 0;
  }
}
