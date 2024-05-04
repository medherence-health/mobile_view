import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medherence/core/utils/size_manager.dart';
import 'package:medherence/features/help_and_support/view/help_and_support.dart';
import 'package:medherence/features/history/view/history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/shared_widget/buttons.dart';
import '../../about/view/about_screen.dart';
import '../../auth/views/login_view.dart';
import '../../profile/view/profile_view.dart';
import '../../settings_feature/view/settings_view.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Future<void> signingOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', false);
  }

  buildLogOutDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            (15),
          ),
        ),
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Logout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: (20),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 35.0,
              right: 35.0,
            ),
            child: Text(
              'Are you sure you want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (18),
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    buttonConfig: ButtonConfig(
                      text: 'LogOut',
                      action: () async {
                        CircularProgressIndicator();
                        await signingOut().then((_) {
                          // Navigate back to home screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()),
                          );
                        });
                      },
                      disabled: false,
                    ),
                    width: 130,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: OutlinePrimaryButton(
                    buttonConfig: ButtonConfig(
                      text: 'Cancel',
                      action: () {
                        Navigator.pop(context);
                      },
                      disabled: true,
                    ),
                    width: 130,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snackbar = SnackBar(
      dismissDirection: DismissDirection.horizontal,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(150),
      content: Text(
        'Coming Soon',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.offWhite,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: AppColors.navBarColor,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins-bold.ttf",
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: SizeMg.height(5)),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                MenuItemCard(
                  icon: Icons.person_rounded,
                  title: 'Profile',
                  subtitle: 'Complete and edit your profile',
                  onPressed: () {
                    // Navigate to profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreenView()),
                    );
                    // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                MenuItemCard(
                  icon: Icons.history,
                  title: 'History',
                  subtitle: 'Your history',
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryScreen())),
                  // Navigate to settings screen
                ),
                const SizedBox(
                  height: 15,
                ),
                MenuItemCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'Personalize and setup your experience',
                  onPressed: () {
                    // Navigate to settings screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsView()));
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                MenuItemCard(
                  icon: CupertinoIcons.chat_bubble_2_fill,
                  title: 'Help and Support',
                  subtitle: 'Report any difficulty you are facing',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpAndSupport()),
                    );

                    // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                MenuItemCard(
                  icon: Icons.feedback_rounded,
                  title: 'About app',
                  subtitle: 'Learn more about the app',
                  onPressed: () {
                    // Navigate to about screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutScreenView()),
                    );
                    // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                MenuItemCard(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  subtitle: 'Logout of your account',
                  onPressed: () async => await buildLogOutDialog()
                  // Navigate to settings screen
                  ,
                ),
                SizedBox(height: SizeMg.height(30)),
                Expanded(child: const Spacer()),
                Text(
                  'Want to rate us? ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeMg.text(20),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins-bold.ttf",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: SizeMg.height(50),
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.star_rate,
                              color: AppColors.navBarColor,
                              size: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.star_rate,
                              color: AppColors.navBarColor,
                              size: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.star_rate,
                              color: AppColors.navBarColor,
                              size: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.star_half,
                              color: AppColors.navBarColor,
                              size: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.star_border,
                              color: AppColors.navBarColor,
                              size: 40,
                            ),
                          ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const MenuItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: AppColors.shadowColor,
      shadowColor: AppColors.progressBarFill,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(1, 1),
                color: AppColors.shadowColor,
              ),
              BoxShadow(
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset(4, 5),
                color: Color.fromRGBO(26, 85, 171, 0.06),
              ),
              BoxShadow(
                blurRadius: 9,
                spreadRadius: 0,
                offset: Offset(10, 10),
                color: Color.fromRGBO(26, 85, 171, 0.04),
              ),
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(17, 18),
                color: Color.fromRGBO(26, 85, 171, 0.01),
              ),
              BoxShadow(
                blurRadius: 11,
                spreadRadius: 0,
                offset: Offset(27, 29),
                color: Color.fromRGBO(26, 85, 171, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    icon,
                    size: 22,
                    color: AppColors.pillIconColor,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: SizeMg.text(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: SizeMg.text(12),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.pillIconColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
