import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'admin_theme_notifier.dart';
import 'constants.dart';

// Model cho Booking
class Booking {
  final int bookingId;
  final int? userId; // Cho phép null
  final int roomId;
  final String checkInDate;
  final String checkOutDate;
  final String bookingTime;
  final String status;

  Booking({
    required this.bookingId,
    this.userId, // Cho phép null
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.bookingTime,
    required this.status,
  });

  // Phương thức chuyển từ JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'],
      userId: json['user_id'], // Có thể là null
      roomId: json['room'],
      checkInDate: json['check_in_date'],
      checkOutDate: json['check_out_date'],
      bookingTime: json['booking_time'],
      status: json['status'],
    );
  }
}

// Hàm đọc dữ liệu từ API
Future<List<Booking>> loadBookings() async {
  String emCre = 'theanh:123456';
  String baseCre = base64Encode(utf8.encode(emCre));

  try {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/employees/bookings/allhistory/'),
      headers: {
        'Authorization': 'Basic $baseCre',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Booking.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  } catch (e) {
    throw Exception('Error loading bookings: $e');
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
        Expanded(
          child: FutureBuilder<List<Booking>>(
            future: loadBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No bookings available.'));
              } else {
                final bookings = snapshot.data!;
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return BookingTile(
                      bookingId: booking.bookingId,
                      userId: booking.userId,
                      roomId: booking.roomId,
                      checkInDate: booking.checkInDate,
                      checkOutDate: booking.checkOutDate,
                      bookingTime: booking.bookingTime,
                      status: booking.status,
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class BookingTile extends StatelessWidget {
  const BookingTile({
    super.key,
    required this.bookingId,
    required this.userId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.bookingTime,
    required this.status,
  });

  final int bookingId;
  final int? userId; // Cho phép null
  final int roomId;
  final String checkInDate;
  final String checkOutDate;
  final String bookingTime;
  final String status;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: defaultPadding * 2,
        vertical: defaultPadding / 2,
      ),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
        borderRadius: BorderRadius.circular(defaultCornerRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          'Booking ID: $bookingId',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: defaultPadding / 2)),
            Text('User ID: ${userId ?? "N/A"}'), // Xử lý null
            Text('Room ID: $roomId'),
            Text('Check-in: $checkInDate'),
            Text('Check-out: $checkOutDate'),
            Text('Booking Time: $bookingTime'),
            Text('Status: $status'),
            const Padding(padding: EdgeInsets.only(top: defaultPadding / 2)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultCornerRadius),
        ),
        onTap: () => debugPrint('Booking $bookingId tapped'),
        splashColor: Colors.transparent,
      ),
    );
  }
}
