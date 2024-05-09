import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/size_manager.dart';
import '../../dashboard_feature/view/dashboard_view.dart';
import '../../monitor/view_model/reminder_view_model.dart';
import '../../more_features/Biometric/biometric_auth.dart';
import '../../more_features/wallet/view/wallet_pin_view.dart';
import '../widget/settings_widget.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isDarkModeEnabled = false;
  void _applyTheme(bool isDarkModeEnabled) {
    if (isDarkModeEnabled) {
      // Apply dark mode theme
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor:
            Colors.black, // Example: Set status bar color for dark mode
      ));
      ThemeData.dark();
    } else {
      // Apply light mode theme
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor:
            Colors.white, // Example: Set status bar color for light mode
      ));
      ThemeData.light();
    }
  }

  @override
  Widget build(BuildContext context) {
    ReminderState reminderState = ReminderState();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25,
            top: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General',
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.dark_mode,
                      color: AppColors.historyBackground,
                      size: 25,
                    ),
                    title: Text(
                      'Dark mode',
                      style: TextStyle(
                        fontSize: SizeMg.text(20),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch.adaptive(
                      value: isDarkModeEnabled, // Use the boolean variable
                      onChanged: (value) {
                        setState(() {
                          isDarkModeEnabled = value; // Update the state
                        });
                        // You can add logic here to apply dark mode
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeMg.height(10)),
              Text(
                'Alarm settings',
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sound',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select Sound'),
                              content: Padding(
                                padding: const EdgeInsets.only(bottom: 38.0),
                                child: DropdownButton<String>(
                                  value: reminderState.selectedSound,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      reminderState
                                          .updateSelectedSound(newValue!);
                                      Navigator.of(context)
                                          .pop(); // Close the dialog after selecting a sound
                                    });
                                  },
                                  items: <String>[
                                    'Aegean Sea',
                                    'Bird Chirping',
                                    'Wind Blowing',
                                    'Water Splash'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            reminderState.selectedSound,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Medhecoin Wallet settings',
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    SettingsWidgetList(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          ImageUtils.lockIcon,
                          height: SizeMg.height(24),
                          width: SizeMg.width(24),
                        ),
                      ),
                      title: 'Change wallet Pin',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WalletPinView()),
                        );
                      },
                    ),
                    SettingsWidgetList(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          ImageUtils.biometricIcon,
                          height: SizeMg.height(24),
                          width: SizeMg.width(24),
                        ),
                      ),
                      title: 'Biometric authentication',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BiometricAuthenticationView()),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
