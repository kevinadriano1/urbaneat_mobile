import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding/onboarding.dart';

void main() {
  runApp(const MyApp());
}

//IMPORTANT: Y'all run the cmd 'dart run flutter_native_splash:create --path=splash.yaml' on your terminal if the black urbaneat
//splash screen isn't immediately displaying when you run the app (if this causes issues chat me)

//don't put in any other widgets here this is for app configs only 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //we're using the inter font for this entire project
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        //i'll change this color scheme later to fit the project more
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      //immediately go to onboarding screen on start-up
      home: OnBoardingScreen(),
    );
  }
}
