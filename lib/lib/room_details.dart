import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2/booking_page.dart';
import 'package:flutter_2/customer_home_page.dart';

class DetailsPage extends StatefulWidget {
  final String type; // Loại phòng
  final String email;
  final String password;

  const DetailsPage({
    Key? key,
    required this.type,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, dynamic>? selectedRoom; // Lưu thông tin phòng được chọn
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRoomData();
  }

  Future<void> loadRoomData() async {
    try {
      // Đọc file JSON từ thư mục assets
      final String jsonString =
          await rootBundle.loadString('assets/data/room_types.json');
      final List<dynamic> data = jsonDecode(jsonString);

      // Tìm thông tin phòng theo `type_name`
      final room = data.firstWhere(
        (room) => room['type_name'] == widget.type,
        orElse: () => null,
      );

      setState(() {
        selectedRoom = room; // Lưu thông tin phòng tìm được
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading room data: $e');
      setState(() {
        selectedRoom = null; // Nếu xảy ra lỗi, đặt thông tin phòng là null
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: const Text(
          'DETAILS',
          style: TextStyle(color: Color(0xFFFFFFF0)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFFFFF0)),
        leading: Transform.scale(
          scale: 1.5,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerHomePage(
                    email: widget.email,
                    password: widget.password,
                  ),
                ),
              );
            },
            child: const Text(
              'HOME', // Chữ hiển thị
              style: TextStyle(
                color: Color(0xfffffff0),
                fontSize: 10, // Kích thước chữ
              ),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 33, 22),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : selectedRoom != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/image/${selectedRoom!['type_name']}.png',
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.5,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 100);
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Room details',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Type: ${selectedRoom!['type_name']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Price: ${selectedRoom!['price']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Description: ${selectedRoom!['description']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 30), // Thay Spacer bằng SizedBox
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingPage(
                                    email: widget.email,
                                    password: widget.password,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              backgroundColor:
                                  const Color.fromARGB(255, 3, 33, 22),
                            ),
                            child: const Text(
                              'Book now',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'Room details not found!',
                  ),
                ),
    );
  }
}
