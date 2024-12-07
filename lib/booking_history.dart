import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingHistory extends StatefulWidget {
  final String email;
  final String phone;
  const BookingHistory({super.key, required this.email, required this.phone});

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
      // Đọc file JSON từ assets
      final String response =
          await rootBundle.loadString('assets/data/booking_history.json');

      // Phân tích cú pháp JSON
      final data = json.decode(response);

      // Kiểm tra cấu trúc JSON
      if (data is Map<String, dynamic> && data['customers'] is List) {
        final customers = List<Map<String, dynamic>>.from(data['customers']);

        // Tìm khách hàng khớp với email và phone
        final customer = customers.firstWhere(
          (cust) =>
              cust['email'] == widget.email && cust['phone'] == widget.phone,
          orElse: () => {},
        );

        if (customer.isNotEmpty && customer['bookingHistory'] is List) {
          setState(() {
            bookingHistory =
                List<Map<String, dynamic>>.from(customer['bookingHistory']);
          });
        } else {
          // Không tìm thấy khách hàng hoặc không có lịch sử đặt phòng
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

  bool getHistory(String email, String phone) {
    return bookingHistory.isEmpty;
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
        title: const Text("Booking History"),
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
                              'Booking ID: ${booking['bookingId']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Room: ${booking['room']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check-in: ${booking['checkInDate']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check-out: ${booking['checkOutDate']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${booking['status']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: booking['status'] == 'Confirmed'
                                    ? Colors.green
                                    : booking['status'] == 'Pending'
                                        ? Colors.orange
                                        : Colors.red,
                              ),
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
