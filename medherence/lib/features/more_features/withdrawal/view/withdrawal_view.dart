import 'package:flutter/material.dart';
import 'package:medherence/core/utils/size_manager.dart';
import 'package:stacked/stacked.dart';

import '../../../../core/utils/color_utils.dart';
import '../../../medhecoin/view_model/medhecoin_wallet_view_model.dart';

class MedhecoinWithdrawalView extends StatelessWidget {
  const MedhecoinWithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return ViewModelBuilder<WalletViewModel>.reactive(
        viewModelBuilder: () => WalletViewModel(),
        builder: (_, model, __) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Withdrawal',
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
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: AppColors.navBarColor),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    25,
                    0,
                    25,
                    25,
                  ),
                  child: Column(
                    children: [
                      Visibility(
                        child: Column(
                          children: [
                            Text(
                              'Saved Accounts',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: SizeMg.text(12),
                              ),
                            ),
                            ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  final item = model.walletModelList[index];
                                  return Column(
                                    children: [
                                      CircleAvatar(
                                        radius: SizeMg.radius(30),
                                        child: Image.asset(
                                          item.src,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        item.firstName + item.lastName,
                                        style: TextStyle(
                                          fontSize: SizeMg.text(12),
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (ctx, index) => SizedBox(
                                      height: SizeMg.width(10),
                                    ),
                                itemCount: model.walletModelList.length)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
