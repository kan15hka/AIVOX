import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_interact/constant.dart';
import 'package:ai_interact/home_page.dart';
import 'package:ai_interact/theme_provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider()..initializeTheme(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    kheight = MediaQuery.of(context).size.height;
    kwidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Interact',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AnimatedSplashScreen(
        splash: 'assets/images/logo.png',
        splashIconSize: 200.0,
        nextScreen: const HomePage(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: (Provider.of<ThemeProvider>(context).theme == 'dark')
            ? Colors.black
            : Colors.white,
        duration: 1500,
      ),
    );
  }
}
