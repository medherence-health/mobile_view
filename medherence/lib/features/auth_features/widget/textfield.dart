import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants_utils/constants.dart';

class TitleAndTextFormField extends StatelessWidget {
  ///The text above the text field
  final String title;

  ///The hint text of the form field
  final String formFieldHint;

  ///The text editing controller of the form field
  final TextEditingController formFieldController;

  ///The keyboard input type
  final TextInputType textInputType;

  ///The enter button of the keyboard action
  final TextInputAction textInputAction;

  ///The filled color of the form field
  final Color formFieldColor;

  ///The validator function of the form field
  final String? Function(String?) formFieldValidator;

  ///List of text input formatters
  final List<TextInputFormatter>? textInputFormatters;

  ///Places a [Text] above a [TextFormField] in a [Column] widget
  const TitleAndTextFormField({
    Key? key,
    required this.title,
    required this.formFieldHint,
    required this.formFieldController,
    required this.textInputAction,
    required this.textInputType,
    required this.formFieldColor,
    required this.formFieldValidator,
    this.textInputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: (18),
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: (10),
        ),
        TextFormField(
          controller: formFieldController,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          style: const TextStyle(
            fontSize: (18),
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          inputFormatters: textInputFormatters,
          decoration: kFormTextDecoration.copyWith(
            hintText: formFieldHint,
            fillColor: formFieldColor,
          ),
          validator: formFieldValidator,
        ),
        const SizedBox(
          height: (25),
        ),
      ],
    );
  }
}
