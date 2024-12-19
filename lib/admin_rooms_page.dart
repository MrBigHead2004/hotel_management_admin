import 'package:flutter/material.dart';
import 'admin_theme_notifier.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  // change the data and columns here
  List<Map<String, dynamic>> rooms = [
    {'name': 'Single Room - 101', 'price': 100, 'availability': 'Available', 'checkInDate': 'N/A', 'checkOutDate': 'N/A'},
    {'name': 'Double Room - 102', 'price': 150, 'availability': 'Occupied', 'checkInDate': '20-12-2024', 'checkOutDate': '24-12-2024'},
    {'name': 'Double Room - 103', 'price': 150, 'availability': 'Available', 'checkInDate': '24-12-2024', 'checkOutDate': '26-12-2024'},
    {'name': 'Double Room - 104', 'price': 150, 'availability': 'Occupied', 'checkInDate': 'N/A', 'checkOutDate': 'N/A'},
    {'name': 'Double Room - 105', 'price': 150, 'availability': 'Available', 'checkInDate': '27-12-2024', 'checkOutDate': '31-12-2024'},
  ];

  String sortedBy = 'name';
  bool ascending = true;

  void sortRooms(String column) {
    setState(() {
      if (sortedBy == column) {
        ascending = !ascending;
      } else {
        sortedBy = column;
        ascending = true;
      }

      rooms.sort((a, b) {
        if (ascending) {
          return a[column].compareTo(b[column]);
        } else {
          return b[column].compareTo(a[column]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(defaultPadding * 2),
        decoration: BoxDecoration(
          color: themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(defaultCornerRadius)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildHeader('Room Name', 'name'),
                  _buildHeader('Price', 'price'),
                  _buildHeader('Availability', 'availability'),
                  _buildHeader('Current Check-in Date', 'checkInDate'),
                  _buildHeader('Current Check-out Date', 'checkOutDate'),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return Row(
                      children: [
                        _buildCell(room['name']),
                        _buildCell('\$${room['price']}'),
                        _buildCell(room['availability']),
                        _buildCell(room['checkInDate']),
                        _buildCell(room['checkOutDate']),
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
        onTap: () => sortRooms(column),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: sortedBy == column ? primaryColor : (themeNotifier.isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: defaultPadding / 2)),
              if (sortedBy == column)
                Icon(
                  ascending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: sortedBy == column ? primaryColor : (themeNotifier.isDarkMode ? Colors.white : Colors.black),
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