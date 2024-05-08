import 'package:flutter/material.dart';
import 'package:medherence/core/model/models/faqs_model.dart';
import 'package:medherence/core/utils/size_manager.dart';

import '../../../../core/utils/color_utils.dart';

class FAQItem extends StatefulWidget {
  final FAQModel faq;

  const FAQItem({required this.faq});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              isExpanded ? Icons.close : Icons.add,
              color: AppColors.navBarColor,
            ),
            title: Text(
              widget.faq.question,
              style: TextStyle(
                fontSize: SizeMg.text(18),
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins-bold.ttf",
              ),
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                widget.faq.answer,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                  fontFamily: "Poppins-bold.ttf",
                ),
              ),
            ),
        ],
      ),
    );
  }
}
