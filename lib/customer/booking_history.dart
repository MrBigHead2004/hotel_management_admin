import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2/customer/booking_page.dart';
import 'package:flutter_2/customer/customer_home_page.dart';

class BookingHistory extends StatefulWidget {
  final int cusid;
  const BookingHistory({super.key, required this.cusid});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  // Danh sách lưu trữ lịch sử đặt phòng
  List<Map<String, dynamic>> bookingHistory = [];
  bool isLoading = true; // Trạng thái tải dữ liệu

  // Hàm tải dữ liệu từ file JSON
  Future<void> loadData() async {
    setState(() {
      isLoading = true; // Bắt đầu tải
    });
    try {
      // Đọc file JSON chứa dữ liệu lịch sử đặt phòng
      final String response =
          await rootBundle.loadString('assets/data/booking.json');

      // Phân tích cú pháp JSON
      final data = json.decode(response);

      // Kiểm tra cấu trúc JSON và chuyển kiểu
      if (data is List) {
        // Chuyển đổi List<dynamic> thành List<Map<String, dynamic>>
        final customerBookings = List<Map<String, dynamic>>.from(data)
            .where(
              (booking) => booking['cus_id'] == widget.cusid,
            )
            .toList();

        if (customerBookings.isNotEmpty) {
          setState(() {
            bookingHistory = customerBookings;
          });
        } else {
          // Không tìm thấy lịch sử đặt phòng cho khách hàng
          setState(() {
            bookingHistory = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No bookings found for this user.")),
          );
        }
      } else {
        throw Exception("Invalid JSON structure");
      }
    } catch (e) {
      // Hiển thị thông báo lỗi nếu không tải được dữ liệu
      print("Error loading data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load booking history: $e')),
      );
      setState(() {
        bookingHistory = [];
      });
    } finally {
      setState(() {
        isLoading = false; // Kết thúc tải
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData(); // Gọi hàm tải dữ liệu khi khởi tạo
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
        leading: Transform.scale(
          scale: 1.5,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerHomePage(
                    cusid: widget.cusid,
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
        actions: <Widget>[
          // Các nút điều hướng
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingPage(
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
          ? const Center(
              child: CircularProgressIndicator()) // Hiển thị khi đang tải
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
                  itemCount: bookingHistory.length, // Số lượng booking
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
                              'Room ID: ${booking['room_id']}',
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
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(), // Thêm phân cách giữa các mục
                ),
    );
  }
}
