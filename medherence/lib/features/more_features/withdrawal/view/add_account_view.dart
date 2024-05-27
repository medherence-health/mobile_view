import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/core/model/models/wallet_model.dart';
import 'package:medherence/core/shared_widget/buttons.dart';
import 'package:medherence/core/utils/size_manager.dart';
import 'package:stacked/stacked.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../medhecoin/view_model/medhecoin_wallet_view_model.dart';

class AddAccountView extends StatefulWidget {
  const AddAccountView({super.key});

  @override
  State<AddAccountView> createState() => _AddAccountViewState();
}

class _AddAccountViewState extends State<AddAccountView> {
  TextEditingController _dropDownSearchController = TextEditingController();
  late TextEditingController _accountNumberController;
  Color? accountFillColor = Colors.white70;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _accountNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return ViewModelBuilder<WalletViewModel>.reactive(
        viewModelBuilder: () => WalletViewModel(),
        builder: (_, model, __) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Add Account',
                style: TextStyle(
                  fontSize: 22,
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
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(
                25.0,
                0,
                25,
                25,
              ),
              child: Column(
                children: [
                  Text(
                    'Add account number to enable secure transactions and easy coin redemption.',
                    style: TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: SizeMg.text(14),
                    ),
                  ),
                  SizedBox(height: SizeMg.height(10)),
                  Text(
                    'Bank',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropDownSearchFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: this._dropDownSearchController,
                      decoration: kFormTextDecoration.copyWith(
                        errorBorder: kFormTextDecoration.errorBorder,
                        hintStyle: kFormTextDecoration.hintStyle,
                        hintText: 'Select Destination Bank',
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        border: kFormTextDecoration.border,
                        focusedBorder: kFormTextDecoration.focusedBorder,
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return model.getSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        tileColor: kFormTextDecoration.fillColor,
                        title: Text(
                          suggestion,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (suggestion) {
                      _dropDownSearchController.text = suggestion;
                      model.selectedBank = suggestion;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please select a bank';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      model.selectedBank = value;
                    },
                    displayAllSuggestionWhenTap: true,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Account Number',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: SizeMg.height(10),
                  ),
                  TextFormField(
                    controller: _accountNumberController,
                    cursorHeight: SizeMg.height(19),
                    decoration: kFormTextDecoration.copyWith(
                      errorBorder: kFormTextDecoration.errorBorder,
                      hintStyle: kFormTextDecoration.hintStyle,
                      border: kFormTextDecoration.border,
                      filled: true,
                      fillColor: accountFillColor,
                      focusedBorder: kFormTextDecoration.focusedBorder,
                      hintText: "Enter Account Number",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy,
                            color: AppColors.navBarColor),
                        iconSize: 24,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: _accountNumberController.text.isNotEmpty
                                ? _accountNumberController.text.trim()
                                : '',
                          ));
                          if (_accountNumberController.text.isNotEmpty)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Text copied to clipboard'),
                              ),
                            );
                        },
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          10), // Limit input to 10 characters
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits
                    ],
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The account number must not be empty";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        if (value!.length == 10 && model.selectedBank != null) {
                          model.validateAccountNumber(
                              model.selectedBank!, value);
                        }
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        // Check if the value is not empty
                        if (value.isNotEmpty) {
                          // If there is input, set filled to true
                          accountFillColor = kFormTextDecoration.fillColor;
                        } else {
                          // If no input, set filled to false
                          model.accountOwnerName = null;
                          accountFillColor = Colors.white70;
                        }
                      });
                    },
                  ),
                  if (model.accountOwnerName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${model.accountOwnerName}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: SizeMg.text(12),
                        ),
                      ),
                    ),
                  SizedBox(height: SizeMg.height(30)),
                  PrimaryButton(
                    buttonConfig:
                        ButtonConfig(text: 'Add Account', action: () {}),
                    width: SizeMg.screenWidth,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
