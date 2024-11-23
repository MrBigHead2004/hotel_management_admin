import 'package:flutter/material.dart';
import 'package:flutter_2/first_page.dart';

//import 'myhomepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Demo',
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}
