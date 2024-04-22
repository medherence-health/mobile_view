import 'package:flutter/material.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/utils/image_utils.dart';
import '../../dashboard_feature/view/dashboard_view.dart';
import '../widgets/about_widget.dart';

class AboutScreenView extends StatelessWidget {
  const AboutScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins-bold.ttf",
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardView()),
            );
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
              AboutWidget(
                  title: 'App Version',
                  subtitle: 'Report any difficulty you are facing',
                  icon: Icons.arrow_forward_ios_rounded,
                  onPressed: () {
                    // Navigate to settings screen
                    // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      ImageUtils.appVersionIcon,
                      height: 24,
                      width: 24,
                    ),
                  )),
              const SizedBox(
                height: 15,
              ),
              AboutWidget(
                icon: Icons.arrow_forward_ios_rounded,
                title: 'Privacy Policy',
                subtitle: 'Data collection, usage and protection',
                onPressed: () {
                  // Navigate to settings screen
                  // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      ImageUtils.privacyPolicyIcon,
                      height: 24,
                      width: 24,
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              AboutWidget(
                icon: Icons.arrow_forward_ios_rounded,
                title: 'About Medherence',
                subtitle: 'Learn more about Medherence Ltd.',
                onPressed: () {
                  // Navigate to settings screen
                  // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    ImageUtils.medherenceAppIcon,
                    height: 24,
                    width: 24,
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
