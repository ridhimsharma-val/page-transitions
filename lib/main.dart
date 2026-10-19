import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/explore_designs_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.mountainBg,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const PageTransitionsApp());
}

class PageTransitionsApp extends StatelessWidget {
  const PageTransitionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Designs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.mountainTheme,
      home: const ExploreDesignsScreen(),
    );
  }
}
