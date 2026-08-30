import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'features/auth/login_screen.dart';

class DentalClinicApp extends StatelessWidget {
  const DentalClinicApp({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DentalCare',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006B72)),
        scaffoldBackgroundColor: const Color(0xFFF7FAFA),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: LoginScreen(config: config),
    );
  }
}
