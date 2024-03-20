import 'package:flutter/material.dart';
import 'package:medherence/features/auth_features/views/forgot_password.dart';
import 'package:medherence/features/auth_features/views/login_view.dart';
import 'package:stacked/stacked.dart';

import '../../home_featue/view/home_view.dart';
import '../view_model/dashboard_view_model.dart';
import '../widgets/bottom_nav_bar.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      viewModelBuilder: () => DashboardViewModel(),
      builder: (_, model, __) => SafeArea(
        child: Scaffold(
          body: _GetDashboardView(
            dashboardIndex: model.currentIndex,
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            model: model,
          ),
        ),
      ),
    );
  }
}

class _GetDashboardView extends StatelessWidget {
  final int dashboardIndex;

  const _GetDashboardView({
    Key? key,
    required this.dashboardIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (dashboardIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const ForgotPasswordScreen();
      default:
        return const LoginView();
    }
  }
}
