import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  // Function to handle login
  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    // Mã hóa username và password thành Base64
    String username = usernameController.text;
    String password = passwordController.text;
    String credentials = '$username:$password';
    String base64Credentials = base64Encode(utf8.encode(credentials));

    final response = await http.post(
      Uri.parse('http://10.13.48.244:8000/users/login/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic $base64Credentials', // Thêm Basic Auth vào header
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        // Truyền thông tin đăng nhập qua Navigator
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookRoomPage(
              username: username,
              password: password,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}

// Booking Page
class BookRoomPage extends StatefulWidget {
  final String username;
  final String password;

  const BookRoomPage(
      {super.key, required this.username, required this.password});

  @override
  State<BookRoomPage> createState() => _BookRoomPageState();
}

class _BookRoomPageState extends State<BookRoomPage> {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  DateTime? checkInDate;
  DateTime? checkOutDate;

  bool isLoading = false;

  // Function to pick a date
  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isCheckIn ? checkInDate : checkOutDate)) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  Future<void> bookRoom() async {
    setState(() {
      isLoading = true;
    });

    // Lấy thông tin đăng nhập từ widget
    String username = widget.username;
    String password = widget.password;

    // Mã hóa Basic Auth (username:password) thành Base64
    String credentials = '$username:$password';
    String base64Credentials = base64Encode(utf8.encode(credentials));

    Map<String, dynamic> bookingData = {
      'customer': int.parse(customerController.text),
      'room': int.parse(roomController.text),
      'check_in_date': checkInDate?.toIso8601String().split('T')[0],
      'check_out_date': checkOutDate?.toIso8601String().split('T')[0],
    };

    final response = await http.post(
      Uri.parse('http://10.13.48.244:8000/api/bookings/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic $base64Credentials', // Thêm Authorization vào header
      },
      body: json.encode(bookingData),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Room booked successfully!'),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to book the room. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Room')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: customerController,
                decoration: const InputDecoration(labelText: 'Customer ID'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: roomController,
                decoration: const InputDecoration(labelText: 'Room ID'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(
                  checkInDate == null
                      ? 'Select Check-In Date'
                      : 'Check-In Date: ${checkInDate!.toLocal()}'
                          .split(' ')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(
                  checkOutDate == null
                      ? 'Select Check-Out Date'
                      : 'Check-Out Date: ${checkOutDate!.toLocal()}'
                          .split(' ')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: bookRoom,
                      child: const Text('Book Room'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
