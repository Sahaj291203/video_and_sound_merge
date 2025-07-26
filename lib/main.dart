import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_task/router/router.dart';

import 'constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video & Sound Merge',
      theme: ThemeData(
        useMaterial3: false,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: primaryBg,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: whiteColor,
          error: errorColor,
          onPrimary: primaryBg,
        ),
        appBarTheme: AppBarTheme(backgroundColor: primaryColor, elevation: 0),
      ),
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
