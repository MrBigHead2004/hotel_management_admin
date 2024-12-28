import 'package:flutter/material.dart';
import 'package:flutter_2/first_page.dart';
import 'package:provider/provider.dart';
import 'admin/constants.dart';
import 'admin/admin_theme_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              textTheme: ThemeData.light().textTheme.apply(
                    fontFamily: 'SF Pro Display',
                    bodyColor: Colors.black,
                    displayColor: Colors.black,
                  ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              textTheme: ThemeData.dark().textTheme.apply(
                    fontFamily: 'SF Pro Display',
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkSecondaryBgColor,
                ),
              ),
            ),
            themeMode:
                themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const FirstPage(),
          );
        },
      ),
    );
  }
}
