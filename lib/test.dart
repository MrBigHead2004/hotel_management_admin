import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _responseMessage = "";

  Future<void> login() async {
    final url =
        Uri.parse("http://192.168.54.60:8000/users/login/"); // API login
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _responseMessage = "Vui lòng điền username và password!";
      });
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print("successs");

        final data = jsonDecode(response.body);
        final token = ''; // Lấy access token
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(token: token),
          ),
        );
      } else {
        setState(() {
          _responseMessage = "Đăng nhập thất bại: ${response.body}";
        });
      }
    } catch (error) {
      setState(() {
        _responseMessage = "Không thể kết nối đến API: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text("Đăng nhập"),
            ),
            SizedBox(height: 20),
            Text(
              _responseMessage,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingScreen extends StatefulWidget {
  final String token;

  BookingScreen({required this.token});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _customerIdController = TextEditingController();
  final _roomIdController = TextEditingController();
  final _checkInController = TextEditingController();
  final _checkOutController = TextEditingController();
  String _responseMessage = "";

  Future<void> createBooking() async {
    final url =
        Uri.parse("http://192.168.54.60:8000/api/bookings/"); // API booking
    final customerId = _customerIdController.text;
    final roomId = _roomIdController.text;
    final checkInDate = _checkInController.text;
    final checkOutDate = _checkOutController.text;

    if (customerId.isEmpty ||
        roomId.isEmpty ||
        checkInDate.isEmpty ||
        checkOutDate.isEmpty) {
      setState(() {
        _responseMessage = "Vui lòng điền đầy đủ thông tin!";
      });
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}', // Thêm Bearer token
        },
        body: jsonEncode({
          'customer_id': int.parse(customerId),
          'room_id': int.parse(roomId),
          'check_in_date': checkInDate,
          'check_out_date': checkOutDate,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _responseMessage = "Đặt phòng thành công!";
        });
      } else {
        setState(() {
          _responseMessage = "Lỗi đặt phòng: ${response.body}";
        });
      }
    } catch (error) {
      setState(() {
        _responseMessage = "Không thể kết nối đến API: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đặt phòng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _customerIdController,
              decoration: InputDecoration(labelText: "Mã khách hàng"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _roomIdController,
              decoration: InputDecoration(labelText: "Mã phòng"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _checkInController,
              decoration:
                  InputDecoration(labelText: "Ngày nhận phòng (YYYY-MM-DD)"),
            ),
            TextField(
              controller: _checkOutController,
              decoration:
                  InputDecoration(labelText: "Ngày trả phòng (YYYY-MM-DD)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createBooking,
              child: Text("Đặt phòng"),
            ),
            SizedBox(height: 20),
            Text(
              _responseMessage,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
