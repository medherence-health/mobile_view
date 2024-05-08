import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/core/shared_widget/buttons.dart';

import '../../../core/utils/color_utils.dart';
import '../../../core/utils/size_manager.dart';

class AppVersionView extends StatelessWidget {
  const AppVersionView({super.key});

  @override
  Widget build(BuildContext context) {
    String _supportMail = 'medherence23@gmail.com';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'App Version',
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
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current App version',
              style: TextStyle(
                color: AppColors.darkGrey,
              ),
            ),
            Text(
              '[App version 1.0.0]',
              style: TextStyle(
                color: AppColors.navBarColor,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Previous App version',
              style: TextStyle(
                color: AppColors.darkGrey,
              ),
            ),
            Text(
              '---',
              style: TextStyle(
                color: AppColors.navBarColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'App Support',
              style: TextStyle(
                color: AppColors.darkGrey,
              ),
            ),
            ListTile(
              title: Text(
                _supportMail,
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.navBarColor,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _supportMail));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Text copied to clipboard'),
                    ),
                  );
                },
                icon: Icon(
                  Icons.copy,
                  color: AppColors.navBarColor,
                  size: 25,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Beta version info',
              style: TextStyle(
                color: AppColors.darkGrey,
              ),
            ),
            Text(
              '---',
              style: TextStyle(
                color: AppColors.navBarColor,
              ),
            ),
            SizedBox(height: 50),
            OutlinePrimaryButton(
              buttonConfig: ButtonConfig(
                text: 'Check for updates',
                action: () {
                  // Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No updates found, you are up to date!'),
                    ),
                  );
                },
                disabled: true,
              ),
              width: SizeMg.width(250),
            ),
          ],
        ),
      ),
    );
  }
}
