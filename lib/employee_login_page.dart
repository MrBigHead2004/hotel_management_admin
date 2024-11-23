import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'employee_home_page.dart'; // Màn hình nhân viên sau khi đăng nhập

class EmployeeLoginPage extends StatefulWidget {
  const EmployeeLoginPage({super.key});

  @override
  State<EmployeeLoginPage> createState() => _EmployeeLoginPageState();
}

class _EmployeeLoginPageState extends State<EmployeeLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Hàm đọc dữ liệu nhân viên từ file JSON
  Future<List<Map<String, String>>> loadAccounts() async {
    String jsonString =
        await rootBundle.rootBundle.loadString('assets/data/data.json');
    Map<String, dynamic> data = jsonDecode(jsonString);
    List<dynamic> accounts = data['accounts'];

    return accounts.map<Map<String, String>>((account) {
      return {
        'username': account['username'],
        'password': account['password'],
      };
    }).toList();
  }

  // Hàm kiểm tra đăng nhập cho nhân viên
  Future<void> checkEmployeeLogin() async {
    List<Map<String, String>> accounts = await loadAccounts();

    String inputUsername = usernameController.text;
    String inputPassword = passwordController.text;

    bool isValid = accounts.any((account) {
      return account['username'] == inputUsername &&
          account['password'] == inputPassword;
    });

    if (isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmployeeHomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Invalid username or password."),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: checkEmployeeLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
