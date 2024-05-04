import 'package:flutter/material.dart';
import 'package:medherence/core/utils/size_manager.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/utils/image_utils.dart';
import '../../dashboard_feature/view/dashboard_view.dart';
import '../widget/support_widget.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    SizeMg.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help and Support',
          style: TextStyle(
            fontSize: SizeMg.text(25),
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins-bold.ttf",
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15,
            top: 44,
          ),
          child: Column(
            children: [
              HelpAndSupportWidget(
                  title: '24/7 Customer care',
                  subtitle: '09123456789',
                  icon: Icons.copy,
                  onPressed: () {
                    // Navigate to settings screen
                    // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      ImageUtils.callIcon,
                      height: SizeMg.height(24),
                      width: SizeMg.width(24),
                    ),
                  )),
              const SizedBox(
                height: 15,
              ),
              HelpAndSupportWidget(
                icon: Icons.copy,
                title: 'Email us at',
                subtitle: 'medherence23@gmail.com',
                onPressed: () {
                  // Navigate to settings screen
                  // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      ImageUtils.emailMessageIcon,
                      height: SizeMg.height(24),
                      width: SizeMg.width(24),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              HelpAndSupportWidget(
                icon: Icons.arrow_forward_ios_rounded,
                title: 'FAQs',
                subtitle: 'Answers to frequently asked questions',
                onPressed: () {
                  // Navigate to settings screen
                  // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      ImageUtils.faqIcon,
                      height: SizeMg.height(24),
                      width: SizeMg.width(24),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              HelpAndSupportWidget(
                icon: Icons.arrow_forward_ios_rounded,
                title: 'App Tour',
                subtitle: 'Tour of the app and its functionalities',
                onPressed: () {
                  // Navigate to settings screen
                  // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    ImageUtils.appTour,
                    height: SizeMg.height(24),
                    width: SizeMg.width(24),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
