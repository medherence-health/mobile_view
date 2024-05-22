import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../core/model/models/wallet_model.dart';

class WalletViewModel extends ChangeNotifier {
  final List<WalletModel> _walletModels = [
    WalletModel(
      src: 'assets/images/bank_logo/firstbank_logo.png',
      title: 'Withdrawal',
      dateTime: '20240418 19:20',
      price: 10000,
      debit: true,
    ),
    WalletModel(
      src: 'assets/images/bank_logo/medherence_icon.png',
      title: 'Adherence Bonus',
      dateTime: '20240417 23:20',
      price: 15101,
      debit: false,
    ),
    WalletModel(
      src: 'assets/images/bank_logo/firstbank_logo.png',
      title: 'Withdrawal',
      dateTime: '20240410 14:43',
      price: 9567.77,
      debit: true,
    ),
    WalletModel(
      src: 'assets/images/bank_logo/medherence_icon.png',
      title: 'Adherence Bonus',
      dateTime: '20240809 10:00',
      price: 9567.77,
      debit: false,
    ),
  ];

  UnmodifiableListView<WalletModel> get walletModelList {
    _walletModels.sort((a, b) => DateTime.parse(b.dateTime)
        .millisecondsSinceEpoch
        .compareTo(DateTime.parse(a.dateTime).millisecondsSinceEpoch));
    return UnmodifiableListView(_walletModels);
  }
}
