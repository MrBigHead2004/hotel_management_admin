import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Thêm HTTP package
import 'customer_home_page.dart';

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  State<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  // 🛡️ Hàm đăng nhập qua API
  Future<void> checkCustomerLogin() async {
    String inputUsername = emailController.text.trim();
    String inputPassword = passwordController.text.trim();

    if (inputUsername.isEmpty || inputPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both username and password')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'http://10.13.19.0:8000/users/login/'), // Thay thế URL API của bạn
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': inputUsername,
          'password': inputPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          int cusId = data['user_id'];

          // ✅ Điều hướng đến trang CustomerHomePage với cus_id
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  CustomerHomePage(
                cusid: cusId,
                username: emailController.text.trim(),
                password: passwordController.text.trim(),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Login failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to login. Try again later.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer Login",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (screenWidth > 800)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _loginForm(),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Image.asset(
                        'assets/image/hotel_login_image.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              else
                _loginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        const Text(
          "Welcome!",
          style: TextStyle(fontSize: 40),
        ),
        const SizedBox(height: 20),
        const Text(
          "Username",
          style: TextStyle(fontSize: 24),
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Username',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Password",
          style: TextStyle(fontSize: 24),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: isLoading ? null : checkCustomerLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 33, 22),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Login',
                      style: TextStyle(fontSize: 20, color: Color(0xFFFFFFF0)),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
