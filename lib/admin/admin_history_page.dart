import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'admin_theme_notifier.dart';
import 'constants.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> bookingHistory = [];
  bool isLoading = true;

  // load booking history data
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    String emCre = 'theanh:123456'; // admin credentials
    String baseCre = base64Encode(utf8.encode(emCre)); // encode credentials

    try {
      // try to load data
      // fetch booking history
      final bookingResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/employees/bookings/allhistory/'),
        headers: {
          'Authorization': 'Basic $baseCre',
          'Content-Type': 'application/json',
        },
      );

      // check if response is successful
      if (bookingResponse.statusCode != 200) {
        throw Exception('Failed to load booking history');
      }

      // decode booking data
      final List<dynamic> bookingData = json.decode(bookingResponse.body);

      // fetch room data
      final roomResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/rooms/'),
        headers: {
          'Authorization': 'Basic $baseCre',
          'Content-Type': 'application/json',
        },
      );

      // check if response is successful
      if (roomResponse.statusCode != 200) {
        throw Exception('Failed to load room data');
      }

      // decode room data
      final List<dynamic> roomData = json.decode(roomResponse.body);

      // create room lookup map
      Map<int, Map<String, dynamic>> roomMap = {};

      // process room data
      for (var room in roomData) {
        try {
          // try to process room data
          roomMap[room['id']] = {
            'name': room['name']?.toString() ?? 'Unknown Room',
            'price': room['price']?.toString() ?? 'N/A'
          };
        } catch (e) {
          print('Error processing room data: $e'); // log error
        }
      }

      // combine booking data with room information
      List<Map<String, dynamic>> bookings = [];
      for (var booking in bookingData) {
        try {
          final roomInfo = roomMap[booking['room']] ??
              {'name': 'Unknown Room', 'price': 'N/A'};

          bookings.add({
            'id': booking['booking_id']?.toString() ?? 'N/A',
            'user_id': booking['user_id']?.toString() ?? 'N/A',
            'room_name': roomInfo['name'],
            'check_in_date': booking['check_in_date']?.toString() ?? 'N/A',
            'check_out_date': booking['check_out_date']?.toString() ?? 'N/A',
            'booking_date': DateTime.parse(booking['booking_time'] ?? 'N/A')
                .toLocal()
                .toString()
                .split('.')[0],
            'price': roomInfo['price'],
            'status': booking['status']?.toString() ?? 'N/A',
          });
        } catch (e) {
          print('Error processing booking: $e');
        }
      }
      bookings.sort((a, b) => int.parse(b['id']).compareTo(int.parse(a['id'])));

      setState(() {
        bookingHistory = bookings;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load booking history: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
                left: defaultPadding * 2,
                right: defaultPadding * 2,
                top: defaultPadding,
                bottom: defaultPadding * 2),
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: themeNotifier.isDarkMode
                  ? darkSecondaryBgColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(defaultCornerRadius),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : bookingHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("No booking history available"),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: loadData,
                              child: const Text("Reload"),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          // Reload button at the top
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: defaultPadding,
                                  right: defaultPadding,
                                  top: defaultPadding,
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: loadData,
                                  icon: const Icon(Icons.refresh,
                                      color: Colors.white),
                                  label: const Text('Reload',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          defaultCornerRadius - defaultPadding),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: defaultPadding),

                          // Booking list
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: loadData,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding / 2),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: bookingHistory.length,
                                itemBuilder: (context, index) {
                                  var booking = bookingHistory[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding / 2,
                                      vertical: defaultPadding / 2,
                                    ),
                                    child: Card(
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            defaultCornerRadius),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            defaultPadding * 2),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              'User ID: ${booking['user_id'] == 'N/A' ? "Walk-in Customer" : booking['user_id']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
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
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Check-out: ${booking['check_out_date']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Booking Date: ${booking['booking_date']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Price: \$${booking['price']} per night',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Status: ${booking['status']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}
