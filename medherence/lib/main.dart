import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medherence/features/splashscreen/splashscreen.dart';
import 'core/service/notification_service.dart';
import 'core/utils/color_utils.dart';
import 'core/utils/utils.dart';
import 'core/model/models/notification_model.dart';
import 'features/monitor/view/alarm_monitor.dart';
import 'features/monitor/view_model/reminder_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NotificationModelItems()),
          ChangeNotifierProvider(create: (context) => ReminderState()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Medical adherence',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            // colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navBarColor),
            colorScheme: const ColorScheme.light(
              primary: AppColors.navBarColor,
            ),
            useMaterial3: true,
            fontFamily: StringUtils.poppins,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: AppColors.navBarColor,
              ),
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.pressedButton,
              selectionHandleColor: AppColors.midOrange,
              selectionColor: AppColors.pressedButton.withOpacity(0.3),
            ),
          ),
          home: const SplashScreen(),
          onGenerateRoute: (routeSettings) {
            if (routeSettings.name == AlarmMonitor.routeName) {
              final arguments = routeSettings.arguments as Map<String, String>;
              final regimen = arguments['regimen'] ?? '';
              final subtitle = arguments['subtitle'] ?? '';
              return MaterialPageRoute(
                builder: (context) => AlarmMonitor(
                  regimen: regimen,
                  subtitle: subtitle,
                ),
              );
            }
            return null;
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
