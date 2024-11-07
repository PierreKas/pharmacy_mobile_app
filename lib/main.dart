import 'package:flutter/material.dart';
import 'package:pharmacy/pages/Introductionpages/onboardingscreen.dart';
import 'package:pharmacy/services/notificationsService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationsService notificationsService = NotificationsService();
  await notificationsService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
