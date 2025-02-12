import 'package:flutter/material.dart';
import 'package:medherence/core/model/models/transaction_model.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../../../core/utils/utils.dart';

class MedhecoinWalletHistory extends StatelessWidget {
  final TransactionModel model;

  const MedhecoinWalletHistory({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return SizedBox(
      child: ListTile(
        leading: CircleAvatar(
          radius: SizeMg.radius(30),
          backgroundColor: Colors.grey[200], // Optional: Set background color
          child: Icon(
            Icons.call_received, // Use Icon widget
            size: 30, // Adjust size as needed
            color: Colors.black, // Adjust color as needed
          ),
        ),
        title: Text(
          model.transactionType,
        ),
        titleTextStyle: TextStyle(
          fontSize: SizeMg.text(16),
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        subtitle: Row(
          children: [
            Text(
              formatDateTime(int.parse(model.transactionDate))["time"] ?? "---",
            ),
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: CircleAvatar(
                radius: 2,
                backgroundColor: AppColors.black,
              ),
            ),
            Text(
              formatDateTime(int.parse(model.transactionDate))["date"] ?? "---",
              // StringUtils.checkToday(DateTime.parse(model.transactionDate)),
            )
          ],
        ),
        subtitleTextStyle: TextStyle(
            fontSize: SizeMg.text(12),
            fontWeight: FontWeight.w400,
            color: AppColors.darkGrey,
            overflow: TextOverflow.ellipsis),
        trailing: RichText(
          text: TextSpan(
            text: model.transactionType == "debit" ? '-\u{20A6}' : '+\u{20A6}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: SizeMg.text(14),
              color: model.transactionType == "debit"
                  ? AppColors.red
                  : AppColors.green,
            ),
            children: [
              TextSpan(
                text: StringUtils.numFormatDecimal(model.amount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
