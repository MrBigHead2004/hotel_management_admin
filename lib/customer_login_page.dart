import 'dart:convert';
import 'package:flutter/material.dart';
import 'customer_home_page.dart'; // Màn hình khách hàng sau khi đăng nhập
import 'package:flutter/services.dart'; // Để sử dụng rootBundle để đọc file JSON

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  State<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<Map<String, dynamic>> customers = [];

  // Hàm tải dữ liệu khách hàng từ file JSON
  Future<void> loadCustomerData() async {
    // Đọc file JSON chứa dữ liệu người dùng
    final String response =
        await rootBundle.loadString('assets/data/customers.json');
    final data = json.decode(response);

    // Chuyển dữ liệu JSON thành danh sách các khách hàng
    setState(() {
      customers = List<Map<String, dynamic>>.from(data);
    });
  }

  // Hàm kiểm tra đăng nhập
  Future<void> checkCustomerLogin() async {
    String inputEmail = emailController.text;
    String inputPassword = passwordController.text;

    // Kiểm tra xem email và mật khẩu có khớp với dữ liệu trong file JSON
    Map<String, dynamic>? validCustomer = customers.firstWhere(
      (customer) =>
          customer['email'] == inputEmail &&
          customer['password'] == inputPassword,
      orElse: () => {},
    );

    if (validCustomer != {}) {
      if (validCustomer['cus_id'] != null) {
        // Lấy cus_id từ dữ liệu người dùng

        // Nếu đăng nhập thành công, chuyển sang trang khách hàng với cus_id
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CustomerHomePage(
              cusid: validCustomer[
                  'cus_id'], // Truyền cus_id thay vì email và password
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
        // Nếu đăng nhập thất bại, hiển thị thông báo lỗi
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Invalid email or password."),
            );
          },
        );
      }
    } else {
      // Nếu đăng nhập thất bại, hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Invalid email or password."),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu người dùng khi trang được khởi tạo
    loadCustomerData();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50),
                          const Center(
                            child: Text(
                              "Welcome!",
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
                            "Password",
                            style: TextStyle(fontSize: 24),
                          ),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
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
                Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Welcome !",
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
                      "Password",
                      style: TextStyle(fontSize: 24),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
