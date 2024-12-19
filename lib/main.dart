import 'package:flutter/material.dart';
import 'package:flutter_2/first_page.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'admin_theme_notifier.dart';
//import 'dart:html' as html;

void main() {
  // Đảm bảo kích thước tối thiểu cho cửa sổ
  // const minWidth = 1000.0; // Ví dụ: chiều ngang tối thiểu
  // const minHeight = 400.0; // Ví dụ: chiều cao tối thiểu

  // html.window.onResize.listen((event) {
  //   // Nếu cửa sổ nhỏ hơn kích thước tối thiểu
  //   if (html.window.innerWidth! < minWidth ||
  //       html.window.innerHeight! < minHeight) {
  //     html.window.resizeTo(
  //       (html.window.innerWidth! < minWidth
  //               ? minWidth
  //               : html.window.innerWidth!)
  //           .toInt(),
  //       (html.window.innerHeight! < minHeight
  //               ? minHeight
  //               : html.window.innerHeight!)
  //           .toInt(),
  //     );
  //   }
  // });

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
            theme: themeNotifier.currentTheme.copyWith(
              textTheme: ThemeData.light().textTheme.apply(
                fontFamily: 'SF Pro Display',
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
                ),
              ),
            ),
            darkTheme: themeNotifier.currentTheme.copyWith(
              textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'SF Pro Display',
              ),
            ),
            home: const FirstPage(),
          );
        },
      ),
    );
  }
}
