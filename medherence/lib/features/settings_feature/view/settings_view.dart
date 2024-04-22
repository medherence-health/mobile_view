import 'package:flutter/material.dart';

import '../../dashboard_feature/view/dashboard_view.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardView()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
    );
  }
}
