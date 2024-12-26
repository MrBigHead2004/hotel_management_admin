// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'customer_home_page.dart'; // Màn hình khách hàng sau khi đăng nhập

// class CustomerLoginPage extends StatefulWidget {
//   const CustomerLoginPage({super.key});

//   @override
//   State<CustomerLoginPage> createState() => _CustomerLoginPageState();
// }

// class _CustomerLoginPageState extends State<CustomerLoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // Hàm kiểm tra đăng nhập thông qua API Django
//   Future<void> checkCustomerLogin() async {
//     String inputEmail = emailController.text;
//     String inputPassword = passwordController.text;

//     try {
//       // Gửi yêu cầu POST đến Django backend
//       final response = await http.post(
//         Uri.parse(
//             'https://your-backend-url/api/login/'), // Thay bằng URL API thực tế của bạn
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'email': inputEmail,
//           'password': inputPassword,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         // Kiểm tra nếu API trả về thông tin đăng nhập hợp lệ
//         if (responseData['status'] == 'success') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Chào mừng, $inputEmail!'),
//               duration: const Duration(seconds: 3),
//             ),
//           );
//           Navigator.pushAndRemoveUntil(
//             context,
//             PageRouteBuilder(
//               pageBuilder: (context, animation, secondaryAnimation) =>
//                   CustomerHomePage(
//                 email: inputEmail,
//               ),
//               transitionsBuilder:
//                   (context, animation, secondaryAnimation, child) {
//                 return FadeTransition(
//                   opacity: animation,
//                   child: child,
//                 );
//               },
//             ),
//             (route) => false,
//           );
//         } else {
//           // Xử lý nếu thông tin đăng nhập không hợp lệ
//           _showErrorDialog('Invalid email or password.');
//         }
//       } else {
//         _showErrorDialog('Failed to login. Please try again.');
//       }
//     } catch (e) {
//       // Xử lý lỗi kết nối
//       _showErrorDialog('An error occurred: $e');
//     }
//   }

//   // Hàm hiển thị thông báo lỗi
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: Text(message),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Customer Login",
//           style: TextStyle(fontSize: 30),
//         ),
//         centerTitle: false,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               if (screenWidth > 800)
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 50),
//                           const Center(
//                             child: Text(
//                               "Welcome!",
//                               style: TextStyle(fontSize: 40),
//                             ),
//                           ),
//                           const SizedBox(height: 50),
//                           const Text(
//                             "Email",
//                             style: TextStyle(fontSize: 24),
//                           ),
//                           TextField(
//                             controller: emailController,
//                             decoration: InputDecoration(
//                               labelText: 'Email',
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 borderSide: BorderSide(
//                                   color: const Color.fromARGB(255, 3, 33, 22)
//                                       .withOpacity(0.3),
//                                   width: 1.5,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(4.0),
//                                 borderSide: BorderSide(
//                                   color: const Color.fromARGB(255, 3, 33, 22)
//                                       .withOpacity(0.8),
//                                   width: 2.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           const Text(
//                             "Password",
//                             style: TextStyle(fontSize: 24),
//                           ),
//                           TextField(
//                             controller: passwordController,
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 borderSide: BorderSide(
//                                   color: const Color.fromARGB(255, 3, 33, 22)
//                                       .withOpacity(0.3),
//                                   width: 1.5,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(4.0),
//                                 borderSide: BorderSide(
//                                   color: const Color.fromARGB(255, 3, 33, 22)
//                                       .withOpacity(0.8),
//                                   width: 2.0,
//                                 ),
//                               ),
//                             ),
//                             obscureText: true,
//                           ),
//                           const SizedBox(height: 20),
//                           Center(
//                             child: SizedBox(
//                               width: double.infinity,
//                               height: 60,
//                               child: TextButton(
//                                 style: TextButton.styleFrom(
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 3, 33, 22),
//                                 ),
//                                 onPressed: checkCustomerLogin,
//                                 child: const Text(
//                                   'Login',
//                                   style: TextStyle(
//                                       fontSize: 20, color: Color(0xFFFFFFF0)),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     if (screenWidth > 800)
//                       Expanded(
//                         flex: 3,
//                         child: Image.asset(
//                           'assets/image/hotel_login_image.jpg',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                   ],
//                 )
//               else
//                 // Bố cục cho màn hình nhỏ hơn
//                 Column(
//                   children: [
//                     const SizedBox(height: 50),
//                     const Text(
//                       "Welcome !",
//                       style: TextStyle(fontSize: 40),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Email",
//                       style: TextStyle(fontSize: 24),
//                     ),
//                     TextField(
//                       controller: emailController,
//                       decoration: InputDecoration(
//                         labelText: 'Email',
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide(
//                             color: const Color.fromARGB(255, 3, 33, 22)
//                                 .withOpacity(0.3),
//                             width: 1.5,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4.0),
//                           borderSide: BorderSide(
//                             color: const Color.fromARGB(255, 3, 33, 22)
//                                 .withOpacity(0.8),
//                             width: 2.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Password",
//                       style: TextStyle(fontSize: 24),
//                     ),
//                     TextField(
//                       controller: passwordController,
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide(
//                             color: const Color.fromARGB(255, 3, 33, 22)
//                                 .withOpacity(0.3),
//                             width: 1.5,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4.0),
//                           borderSide: BorderSide(
//                             color: const Color.fromARGB(255, 3, 33, 22)
//                                 .withOpacity(0.8),
//                             width: 2.0,
//                           ),
//                         ),
//                       ),
//                       obscureText: true,
//                     ),
//                     const SizedBox(height: 20),
//                     Center(
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 60,
//                         child: TextButton(
//                           style: TextButton.styleFrom(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 3, 33, 22),
//                           ),
//                           onPressed: checkCustomerLogin,
//                           child: const Text(
//                             'Login',
//                             style: TextStyle(
//                                 fontSize: 20, color: Color(0xFFFFFFF0)),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Image.asset(
//                       'assets/image/hotel_login_image.jpg',
//                       fit: BoxFit.cover,
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
