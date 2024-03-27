import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/shared_widget/buttons.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  buildLogOutDialog()async {
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
                PrimaryButton(
                  buttonConfig: ButtonConfig(
                    text: 'LogOut',
                    action: () {
                      Navigator.pop(context);
                    },
                    disabled: false,
                  ), width: 150,
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: OutlinePrimaryButton(
                    buttonConfig: ButtonConfig(
                      text: 'Cancel',
                      action: () {
                        Navigator.pop(context);
                      },
                      disabled: true,
                    ),width: 150,
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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
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
            Text(
              'Menu',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins-bold.ttf",
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 44,
            ),
            MenuItemCard(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Personalize and setup your experience',
              onPressed: () {
                // Navigate to settings screen
              },
            ),
            SizedBox(
              height: 15,
            ),
            MenuItemCard(
              icon: CupertinoIcons.chat_bubble_2_fill,
              title: 'Help and Support',
              subtitle: 'Report any difficulty you are facing',
              onPressed: () {
                // Navigate to settings screen
              },
              
            ),
            SizedBox(
              height: 15,
            ),
            MenuItemCard(
              icon: Icons.feedback_rounded,
              title: 'About app',
              subtitle: 'Learn more about the app',
              onPressed: () {
                // Navigate to settings screen
              },
            ),
            SizedBox(
              height: 15,
            ),
            MenuItemCard(
              icon: Icons.logout_rounded,
              title: 'Logout',
              subtitle: 'Logout of your account',
              onPressed: 
                ()async => await buildLogOutDialog()
                // Navigate to settings screen
              ,
            ),
            Spacer(),
            Text(
              'Want to rate us? ',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins-bold.ttf",
              ),
            ),
            SizedBox(height: 15,),
            
          ],
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
          decoration: BoxDecoration(
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
                    size: 24,
                    color: AppColors.pillIconColor,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
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
