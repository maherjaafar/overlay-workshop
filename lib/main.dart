import 'package:flutter/material.dart';
import 'package:overlays_workshop/src/core/ui/themes/app_themes.dart';
import 'package:overlays_workshop/src/features/home/presentation/widgets/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemes.defaultTheme,
      home: const MyHomePage(
        title: 'Creating top-notch flutter apps with overlays',
      ),
    );
  }
}
