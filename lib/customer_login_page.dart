import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'customer_home_page.dart'; // Màn hình khách hàng sau khi đăng nhập

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  State<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Hàm tải dữ liệu khách hàng từ GitHub
  Future<List<Map<String, String>>> loadCustomers() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/nttheanh404/testdata/refs/heads/main/customers.json'));

    if (response.statusCode == 200) {
      List<dynamic> customers = json.decode(response.body)['customers'];

      return customers.map<Map<String, String>>((customer) {
        return {
          'email': customer['email'],
          'phone': customer['phone'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load customers data');
    }
  }

  // Hàm kiểm tra đăng nhập cho khách hàng
  Future<void> checkCustomerLogin() async {
    List<Map<String, String>> customers = await loadCustomers();

    String inputEmail = emailController.text;
    String inputPhone = phoneController.text;

    bool isValid = customers.any((customer) {
      return customer['email'] == inputEmail && customer['phone'] == inputPhone;
    });

    if (isValid) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CustomerHomePage(
            email: inputEmail,
            phone: inputPhone,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        (route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Invalid email or phone number."),
          );
        },
      );
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
              // Bố cục sẽ thay đổi linh hoạt theo kích thước màn hình
              if (screenWidth > 800)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form đăng nhập
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50),
                          const Center(
                            child: Text(
                              "Welcome back!",
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                          const SizedBox(height: 50),
                          const Text(
                            "Email",
                            style: TextStyle(fontSize: 24),
                          ),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 3, 33, 22)
                                      .withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 3, 33, 22)
                                      .withOpacity(0.8),
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Phone number",
                            style: TextStyle(fontSize: 24),
                          ),
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 3, 33, 22)
                                      .withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 3, 33, 22)
                                      .withOpacity(0.8),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 3, 33, 22),
                                ),
                                onPressed: checkCustomerLogin,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xFFFFFFF0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Hình ảnh bên cạnh
                    if (screenWidth > 800)
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
                // Bố cục cho màn hình nhỏ hơn
                Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Welcome back!",
                      style: TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Email",
                      style: TextStyle(fontSize: 24),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 3, 33, 22)
                                .withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 3, 33, 22)
                                .withOpacity(0.8),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Phone number",
                      style: TextStyle(fontSize: 24),
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 3, 33, 22)
                                .withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 3, 33, 22)
                                .withOpacity(0.8),
                            width: 2.0,
                          ),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 3, 33, 22),
                          ),
                          onPressed: checkCustomerLogin,
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20, color: Color(0xFFFFFFF0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/image/hotel_login_image.jpg',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
