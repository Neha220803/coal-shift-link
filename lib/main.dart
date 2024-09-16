import 'package:flutter/material.dart';
import 'package:shift_link/home_nav_page.dart';
import 'package:shift_link/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: const {
          // '/login': (context) => const LogInPage(),
          // other routes
        },
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        home: const HomeNavPage());
  }
}
