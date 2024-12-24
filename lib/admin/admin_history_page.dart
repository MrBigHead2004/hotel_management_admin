import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'admin_theme_notifier.dart';
import 'constants.dart';

// Model cho Booking
class Booking {
  final int cusId;
  final int bookId;
  final String name;
  final String checkInDate;
  final String checkOutDate;
  final String bookingDate;
  final int price;
  final String status;
  Booking(
      {required this.bookId,
      required this.cusId,
      required this.name,
      required this.checkInDate,
      required this.checkOutDate,
      required this.bookingDate,
      required this.price,
      required this.status});

  // Phương thức chuyển từ JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
        bookId: json['booking_id'],
        cusId: json['cus_id'],
        name: json['name'],
        checkInDate: json['check_in_date'],
        checkOutDate: json['check_out_date'],
        bookingDate: json['booking_date'],
        price: json['price'],
        status: json['status']);
  }
}

// Hàm đọc dữ liệu từ file JSON
Future<List<Booking>> loadBookings() async {
  final String jsonString =
      await rootBundle.loadString('assets/data/booking.json');
  final List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((data) => Booking.fromJson(data)).toList();
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
                        bookId: booking.bookId,
                        cusId: booking.cusId,
                        name: booking.name,
                        checkInDate: booking.checkInDate,
                        checkOutDate: booking.checkOutDate,
                        bookingDate: booking.bookingDate,
                        price: booking.price,
                        status: booking.status);
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
  const BookingTile(
      {super.key,
      required this.bookId,
      required this.cusId,
      required this.name,
      required this.checkInDate,
      required this.checkOutDate,
      required this.bookingDate,
      required this.price,
      required this.status});
  final int bookId;
  final int cusId;
  final String status;
  final String name;
  final String checkInDate;
  final String checkOutDate;
  final String bookingDate;
  final int price;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 2, vertical: defaultPadding / 2),
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
        title: Text('Booking $bookId',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: defaultPadding / 2)),
            Text('Customer ID: $cusId'),
            Text('Room ID: $name'),
            Text('Check-in: $checkInDate'),
            Text('Check-out: $checkOutDate'),
            Text('Booking Date: $bookingDate'),
            Text('Price: \$${price.toString()}'),
            Text('Status: $status'),
            const Padding(padding: EdgeInsets.only(top: defaultPadding / 2)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultCornerRadius)),
        onTap: () => debugPrint('Booking $bookId tapped'),
        splashColor: Colors.transparent,
      ),
    );
  }
}
