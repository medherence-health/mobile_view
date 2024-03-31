import 'package:flutter/material.dart';
import 'package:medherence/core/constants_utils/color_utils.dart';

class PrimaryButton extends StatelessWidget {
  final ButtonConfig buttonConfig;
  final double height;
  final EdgeInsets? margin;
  final double width;
  final Color color, textColor;
  final double? textSize; 

  const PrimaryButton({
    Key? key,
    required this.buttonConfig,
    this.textSize = 25.0,
    this.height = 54.0,
    this.margin,
    required this.width,
    this.textColor = AppColors.white,
    this.color = AppColors.mainPrimaryButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        height: height,
        width: width,
        margin: margin ?? const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: buttonConfig.disabled ? AppColors.disabledButton : color,
          borderRadius: BorderRadius.circular(
            (10),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: buttonConfig.disabled ? null : buttonConfig.action,
            highlightColor: AppColors.disabledButton,
            child: Center(
              child: Text(
                buttonConfig.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color:
                      buttonConfig.disabled ? Colors.grey.shade500 : textColor,
                  fontSize: textSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlinePrimaryButton extends StatelessWidget {
  final ButtonConfig buttonConfig;
  final double height;
  final EdgeInsets? margin;
  final double width;
  final Color color, textColor;
  final Icon? icon;
  final double? textSize;

  const OutlinePrimaryButton({
    Key? key,
    required this.buttonConfig,
    this.icon,
    this.height = 54.0,
    this.textSize = 25,
    this.margin,
    this.width = double.infinity,
    this.textColor = AppColors.mainPrimaryButton,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        height: height,
        width: width,
        margin: margin ?? const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            (10),
          ),
          border: Border.all(
            color: AppColors.pressedButton,
            width: 2.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: buttonConfig.action,
            highlightColor: AppColors.disabledButton,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (icon != null) icon?? Icon(Icons.hourglass_empty),
                  Text(
                    buttonConfig.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      fontSize: textSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonConfig {
  final String text;
  final VoidCallback action;
  final bool disabled;
  ButtonConfig(
    {
    required this.text,
    required this.action,
    this.disabled = false,
  });
}
