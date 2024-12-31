import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  // Add these variables for sorting
  String _sortColumn = 'name'; // Default sort by room name
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    loadRoomsAndBookings();
  }

  /// Load dữ liệu phòng và lịch đặt phòng từ API
  Future<void> loadRoomsAndBookings() async {
    String emCre = 'theanh:123456';
    String baseCre = base64Encode(utf8.encode(emCre));

    try {
      // Fetch rooms data
      final http.Response roomResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/rooms/'),
        headers: {
          'Authorization': 'Basic $baseCre',
          'Content-Type': 'application/json',
        },
      );

      // Fetch bookings data
      final http.Response bookingResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/employees/bookings/allhistory/'),
        headers: {
          'Authorization': 'Basic $baseCre',
          'Content-Type': 'application/json',
        },
      );

      if (roomResponse.statusCode == 200 && bookingResponse.statusCode == 200) {
        final List<dynamic> roomsData = json.decode(roomResponse.body);
        final List<dynamic> bookingsData = json.decode(bookingResponse.body);
        roomsData.sort(
            (a, b) => int.parse(a['name']).compareTo(int.parse(b['name'])));
        setState(() {
          rooms = List<Map<String, dynamic>>.from(roomsData);
          bookings = List<Map<String, dynamic>>.from(bookingsData);
          availableRooms = List<Map<String, dynamic>>.from(rooms);
        });
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
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
          return booking['room'] == room['id'] &&
              booking['status'] == "Confirmed";
        }).toList();

        // Kiểm tra nếu phòng này bị đặt trong khoảng thời gian chọn
        for (var booking in roomBookings) {
          DateTime bookingCheckIn = DateTime.parse(booking['check_in_date']);
          DateTime bookingCheckOut = DateTime.parse(booking['check_out_date']);

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

  void _sortRooms(String column) {
    setState(() {
      if (_sortColumn == column) {
        // If clicking the same column, reverse the sort order
        _isAscending = !_isAscending;
      } else {
        // If clicking a different column, set it as the sort column and default to ascending
        _sortColumn = column;
        _isAscending = true;
      }

      availableRooms.sort((a, b) {
        var aValue = a[column];
        var bValue = b[column];

        // Handle numeric values (like price)
        if (aValue is num && bValue is num) {
          return _isAscending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }

        // Handle string values
        return _isAscending
            ? aValue.toString().compareTo(bValue.toString())
            : bValue.toString().compareTo(aValue.toString());
      });
    });
  }

  Widget _buildHeader(String title, String column) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isSelected = _sortColumn == column;

    return InkWell(
      onTap: () => _sortRooms(column),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: isSelected
                    ? primaryColor
                    : themeNotifier.isDarkMode
                        ? Colors.white
                        : Colors.black,
              ),
            ),
            if (_sortColumn == column) ...[
              const SizedBox(width: 4),
              Icon(
                _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: isSelected
                    ? primaryColor
                    : themeNotifier.isDarkMode
                        ? Colors.white
                        : Colors.black,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
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
            // Hàng chọn ngày
            Row(
              children: [
                ElevatedButton(
                  onPressed: pickDateRange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          defaultCornerRadius - defaultPadding),
                    ),
                  ),
                  child: const Text('Select Check-in & Check-out Dates',
                      style: TextStyle(color: Colors.white)),
                ),
                if (selectedCheckIn != null && selectedCheckOut != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'From: ${selectedCheckIn!.toLocal().toString().split(' ')[0]} To: ${selectedCheckOut!.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: defaultPadding),

            // Updated header row
            Row(
              children: [
                Expanded(child: _buildHeader('No.', 'id')),
                Expanded(child: _buildHeader('Room ID', 'name')),
                Expanded(child: _buildHeader('Room Type', 'room_types')),
                Expanded(child: _buildHeader('Price', 'price')),
              ],
            ),

            // Danh sách các phòng
            Expanded(
              child: ListView.builder(
                itemCount: availableRooms.length,
                itemBuilder: (context, index) {
                  final room = availableRooms[index];
                  return Row(
                    children: [
                      Expanded(
                          child:
                              _buildCell((index + 1).toString())), // Số thứ tự
                      Expanded(child: _buildCell(room['name'])), // Tên phòng
                      Expanded(
                          child: _buildCell(
                              room['room_types'].toString())), // Loại phòng
                      Expanded(child: _buildCell('\$${room['price']}')), // Giá
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(String value) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Text(
        value,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}
