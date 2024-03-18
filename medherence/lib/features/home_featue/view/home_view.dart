import 'package:flutter/material.dart';

import '../../../core/shared_widget/buttons.dart';
import '../widget/medecoin_widget.dart';
import '../widget/progressStreak.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  buildCompleteProfile() async {
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
              'Complete Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(
            height: (20),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
            ),
            child: Text(
              'To unlock the full potential of the Medherence app, you are to complete your user profile',
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
            child: PrimaryButton(
              buttonConfig: ButtonConfig(
                text: 'Complete Profile',
                action: () {
                  Navigator.pop(context);
                },
                disabled: false,
              ),
            ),
          ),
        ],
      ),
    );
    await Future.delayed(
      const Duration(
        seconds: 5,
      ),
    );
  }

  int progress = 1;
  String title = 'ADB'; // Initial title

  void updateProgress() {
    setState(() {
      progress++;
      // Update title based on progress
      if (progress == 1) {
        title = 'ADB';
      } else if (progress == 2) {
        title = 'Serg';
      } else if (progress == 3) {
        title = 'Lt.';
      } else {
        // Custom logic for further progress titles
        title = 'Master ${progress - 2}';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      buildCompleteProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25.0,
        right: 20,
        left: 20,
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome, $title',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins-bold.ttf",
                  ),
                ), // Display dynamic title
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_sharp,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    // Handle notification button press
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                ProgressStreak(
                    progress: progress), // Display progress streak bar
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     // Simulate completion of an action
                //     if (progress < 10) {
                //       updateProgress();
                //     }
                //   },
                //   child: Text('Complete Action'),
                // ),
                MedhecoinWidget(),
                SizedBox(height: 40),
                Text(
                  'Next Regimen',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins-Bold.ttf",
                    fontSize: 25,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
