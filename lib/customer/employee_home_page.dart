import 'package:flutter/material.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeState();
}

class _EmployeeState extends State<EmployeeHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Title(color: const Color(0xffffffff), child: const Text('hello')),
      ),
      body: const Placeholder(),
    );
  }
}
