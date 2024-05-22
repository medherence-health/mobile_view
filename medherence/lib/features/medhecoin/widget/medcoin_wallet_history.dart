import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../../../core/model/models/wallet_model.dart';
import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../../../core/utils/utils.dart';

class MedhecoinWalletHistory extends StatelessWidget {
  final WalletModel model;

  const MedhecoinWalletHistory({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return SizedBox(
      child: ListTile(
        leading: CircleAvatar(
          radius: SizeMg.radius(35),
          child: FittedBox(
            child: Image.asset(model.src),
          ),
        ),
        title: Text(
          model.title,
        ),
        titleTextStyle: TextStyle(
          fontSize: SizeMg.text(14),
          fontWeight: FontWeight.w400,
        ),
        subtitle: Row(
          children: [
            Text(
              Jiffy.parse(model.dateTime, pattern: 'EEEE, do MMMM, yyyy')
                  .format(pattern: 'EEEE, do MMMM, yyyy'),
            ),
            CircleAvatar(
              radius: 4,
              backgroundColor: AppColors.black,
            ),
            Text(
              StringUtils.formatTime12(DateTime.parse(model.dateTime)),
            )
          ],
        ),
        subtitleTextStyle: TextStyle(
          fontSize: SizeMg.text(10),
          fontWeight: FontWeight.w400,
        ),
        trailing: RichText(
          text: TextSpan(
            text: '\u{20A6}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: SizeMg.text(16),
              color: model.debit ? AppColors.red : AppColors.green,
            ),
            children: [
              TextSpan(
                text: StringUtils.numFormatDecimal(model.price),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
