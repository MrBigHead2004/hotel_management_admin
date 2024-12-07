import 'package:flutter/material.dart';
import 'package:flutter_2/customer_home_page.dart';
import 'package:flutter_2/customer_login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;

  // Hàm để chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Register New Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Trường nhập email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Trường nhập phone
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Trường nhập name
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Trường chọn ngày sinh
              Row(
                children: [
                  const Text("Birth of Date: "),
                  const SizedBox(width: 10),
                  Text(
                    selectedDate == null
                        ? 'No Date Chosen!'
                        : '${selectedDate!.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text("Pick a Date"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Nút đăng ký
              ElevatedButton(
                onPressed: () {
                  // Xử lý đăng ký ở đây
                  String email = emailController.text;
                  String phone = phoneController.text;
                  String name = nameController.text;

                  if (email.isNotEmpty &&
                      phone.isNotEmpty &&
                      name.isNotEmpty &&
                      selectedDate != null) {
                    // Gửi dữ liệu hoặc lưu thông tin người dùng
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration Successful')),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            CustomerHomePage(
                          email: email,
                          phone: phone,
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
                    // Điều hướng đến trang tiếp theo
                  } else {
                    // Thông báo lỗi nếu có trường trống
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  }
                },
                child: const Text('Register'),
              ),
              const Text('already has an account ?'),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerLoginPage(),
                      ),
                    );
                  },
                  child: const Text('login here'))
            ],
          ),
        ),
      ),
    );
  }
}
