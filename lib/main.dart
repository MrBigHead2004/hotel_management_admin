import 'package:flutter/material.dart';
import 'package:flutter_2/first_page.dart';
import 'package:provider/provider.dart';
//import 'admin/constants.dart';
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
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            // theme: themeNotifier.currentTheme.copyWith(
            //   textTheme: ThemeData.light().textTheme.apply(
            //         fontFamily: 'SF Pro Display',
            //       ),
            //   elevatedButtonTheme: ElevatedButtonThemeData(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: themeNotifier.isDarkMode
            //           ? darkSecondaryBgColor
            //           : Colors.white,
            //     ),
            //   ),
            // ),
            // darkTheme: themeNotifier.currentTheme.copyWith(
            //   textTheme: ThemeData.dark().textTheme.apply(
            //         fontFamily: 'SF Pro Display',
            //       ),
            // ),
            home: FirstPage(),
          );
        },
      ),
    );
  }
}
