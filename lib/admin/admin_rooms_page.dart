import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'admin_theme_notifier.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  List<Map<String, dynamic>> rooms = [];
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> availableRooms = [];
  DateTime? selectedCheckIn;
  DateTime? selectedCheckOut;

  @override
  void initState() {
    super.initState();
    loadRoomsAndBookings();
  }

  /// Load dữ liệu phòng và lịch đặt phòng từ file JSON
  Future<void> loadRoomsAndBookings() async {
    // Load rooms data
    final String roomsResponse =
        await rootBundle.loadString('assets/data/room_to_book.json');
    final List<dynamic> roomsData = json.decode(roomsResponse);

    // Load bookings data
    final String bookingsResponse =
        await rootBundle.loadString('assets/data/booking.json');
    final List<dynamic> bookingsData = json.decode(bookingsResponse);

    setState(() {
      rooms = List<Map<String, dynamic>>.from(roomsData);
      bookings = List<Map<String, dynamic>>.from(bookingsData);
      availableRooms = List<Map<String, dynamic>>.from(rooms);
    });
  }

  /// Lọc các phòng còn trống dựa trên khoảng thời gian đã chọn
  void filterAvailableRooms() {
    if (selectedCheckIn == null || selectedCheckOut == null) {
      setState(() {
        availableRooms = List<Map<String, dynamic>>.from(rooms);
      });
      return;
    }

    setState(() {
      availableRooms = rooms.where((room) {
        // Lấy danh sách các booking liên quan đến phòng này
        final roomBookings = bookings.where((booking) {
          return booking['name'] == room['name'];
        }).toList();

        // Kiểm tra nếu phòng này có bị đặt trong khoảng thời gian chọn
        for (var booking in roomBookings) {
          DateTime bookingCheckIn = DateTime.parse(booking['check_in_date']);
          DateTime bookingCheckOut = DateTime.parse(booking['check_out_date']);

          // Nếu có trùng lịch thì phòng này không available
          if (!(selectedCheckOut!.isBefore(bookingCheckIn) ||
              selectedCheckIn!.isAfter(bookingCheckOut))) {
            return false;
          }
        }

        return true; // Không trùng lịch, phòng còn trống
      }).toList();
    });
  }

  /// Chọn ngày Check-in và Check-out
  Future<void> pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        selectedCheckIn = picked.start;
        selectedCheckOut = picked.end;
      });
      filterAvailableRooms();
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(defaultPadding * 2),
        decoration: BoxDecoration(
          color: themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultCornerRadius)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: pickDateRange,
                    child: const Text('Select Check-in & Check-out Dates'),
                  ),
                  if (selectedCheckIn != null && selectedCheckOut != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'From: ${selectedCheckIn!.toLocal().toString().split(' ')[0]} To: ${selectedCheckOut!.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    )
                ],
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  _buildHeader('No.', 'index'),
                  _buildHeader('Room ID', 'name'),
                  _buildHeader('Room Type', 'room_type'),
                  _buildHeader('Price', 'price'),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: availableRooms.length,
                  itemBuilder: (context, index) {
                    final room = availableRooms[index];
                    return Row(
                      children: [
                        _buildCell((index + 1).toString()),
                        _buildCell(room['name']),
                        _buildCell(room['room_type']),
                        _buildCell('\$${room['price']}'),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title, String column) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Expanded(
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Text(value, style: const TextStyle(fontSize: 16.0)),
      ),
    );
  }
}
