import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class SaxoBankingApp extends StatelessWidget {
  const SaxoBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAXO Banking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        // Use Cupertino-style page transitions
        return CupertinoPageRoute(
          builder: (context) {
            switch (settings.name) {
              case '/':
                return const SplashScreen();
              default:
                return const SplashScreen();
            }
          },
          settings: settings,
        );
      },
    );
  }
}
