import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding/onboarding.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 187, 187, 187),
      onPrimary: Colors.black, //text/icon on primary bg color
      secondary: Color.fromARGB(255, 100, 100, 100), 
      onSecondary: Colors.black, // text/icon color on secondary bg
      tertiary: Color.fromARGB(255, 0, 0, 0), 
      onTertiary: Color.fromARGB(255, 255, 255, 255), // text/icon color on tertiary bg
      surface: Colors.white, // surface color for cards, sheets, etc.
      onSurface: Colors.black, // text/icon color on surface
      error: Color(0xFFB00020), // error color
      onError: Colors.white, // text/icon color on error background
    );

    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'UrbanEat',
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          colorScheme: colorScheme,
          useMaterial3: true, 
        ),
        debugShowCheckedModeBanner: false,
        home: OnBoardingScreen(),
      ),
    );
  }
}
