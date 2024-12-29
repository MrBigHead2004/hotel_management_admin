import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_2/customer/booking_page.dart';
import 'package:flutter_2/customer/customer_home_page.dart';

class BookingHistory extends StatefulWidget {
  final int cusid;
  final String username;
  final String password;

  const BookingHistory({
    super.key,
    required this.cusid,
    required this.password,
    required this.username,
  });

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  List<Map<String, dynamic>> bookingHistory = [];
  bool isLoading = true;

  /// Fetch booking data from API
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    String username = widget.username;
    String password = widget.password;
    String credentials = '$username:$password';
    String base64Credentials = base64Encode(utf8.encode(credentials));

    try {
      // 📥 1. Lấy dữ liệu booking history
      final bookingResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/bookings/history/'),
        headers: {
          'Authorization': 'Basic $base64Credentials',
          'Content-Type': 'application/json',
        },
      );

      if (bookingResponse.statusCode != 200) {
        throw Exception('Failed to load booking history');
      }

      final List<dynamic> bookingData = json.decode(bookingResponse.body);
      // 📥 2. Lấy dữ liệu tất cả các phòng
      final roomResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/rooms/'),
        headers: {
          'Authorization': 'Basic $base64Credentials',
          'Content-Type': 'application/json',
        },
      );
      if (roomResponse.statusCode != 200) {
        throw Exception('Failed to load room data');
      }
      final List<dynamic> roomData = json.decode(roomResponse.body);

      // 🔄 3. Chuyển dữ liệu phòng thành Map để tra cứu nhanh
      Map<int, Map<String, dynamic>> roomMap = {
        for (var room in roomData)
          room['id']: {'name': room['name'], 'price': room['price'] ?? 'N/A'}
      };

      // 📝 4. Kết hợp dữ liệu booking với tên và giá phòng
      List<Map<String, dynamic>> bookings = bookingData.map((booking) {
        final roomInfo = roomMap[booking['room']] ??
            {'name': 'Unknown Room', 'price': 'N/A'};
        return {
          'id': booking['booking_id'],
          'room_name': roomInfo['name'],
          'check_in_date': booking['check_in_date'],
          'check_out_date': booking['check_out_date'],
          'booking_date': DateTime.parse(booking['booking_time'] ?? 'N/A')
              .toLocal() // Chuyển về múi giờ cục bộ của thiết bị
              .toString()
              .split('.')[0],
          'price': roomInfo['price'], // Lấy giá phòng từ room API
          'status': booking['status'],
        };
      }).toList();
      bookings.sort((a, b) => b['id'].compareTo(a['id']));
      setState(() {
        bookingHistory = bookings;
      });
    } catch (e) {
      //print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load booking history: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: const Text(
          'Hotel IT3180',
          style: TextStyle(color: Color(0xFFFFFFF0), fontSize: 40),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFFFFF0)),
        leading: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerHomePage(
                  password: widget.password,
                  username: widget.username,
                  cusid: widget.cusid,
                ),
              ),
            );
          },
          child: const Text(
            'HOME',
            style: TextStyle(color: Color(0xfffffff0), fontSize: 10),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingPage(
                    password: widget.password,
                    username: widget.username,
                    cusid: widget.cusid,
                  ),
                ),
              );
            },
            child: const Text(
              'BOOK',
              style: TextStyle(color: Color(0xFFFFFFF0)),
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 3, 33, 22),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingHistory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          "No booking history available, book some rooms now :)"),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadData,
                        child: const Text("Reload"),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: bookingHistory.length,
                  itemBuilder: (context, index) {
                    var booking = bookingHistory[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking ID: ${booking['id']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Room: ${booking['room_name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check-in: ${booking['check_in_date']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check-out: ${booking['check_out_date']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Booking Date: ${booking['booking_date']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Price: \$${booking['price']} per day',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${booking['status']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
    );
  }
}
