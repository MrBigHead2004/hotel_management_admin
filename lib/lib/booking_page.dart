import 'package:flutter/material.dart';
import 'package:flutter_2/booking_history.dart';
import 'package:flutter_2/customer_home_page.dart';
// import 'package:flutter_2/customer_home_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Map<String, Map<String, dynamic>> selectedRooms = {};

  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now();
    checkOutDate = checkInDate!.add(const Duration(days: 1));
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate = isCheckIn
        ? (checkInDate ?? DateTime.now())
        : (checkOutDate ?? checkInDate!.add(const Duration(days: 1)));
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime(2101);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = pickedDate;
          if (checkOutDate == null || checkOutDate!.isBefore(checkInDate!)) {
            checkOutDate = checkInDate!.add(const Duration(days: 1));
          }
        } else {
          if (pickedDate.isAfter(checkInDate!)) {
            checkOutDate = pickedDate;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Check-out date must be after Check-in date.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      });
    }
  }

  double calculateTotalPrice() {
    double total = 0.0;

    if (checkInDate != null && checkOutDate != null) {
      int numNights = checkOutDate!.difference(checkInDate!).inDays;

      selectedRooms.forEach((roomName, details) {
        double roomPrice = details['price'];
        total += roomPrice * numNights;
      });
    }
    return total;
  }

  Widget buildRoomGrid() {
    List<String> roomTypes = ['DDR', 'EDR', 'JSD'];
    List<double> roomPrices = [100, 150, 200];

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8, // 8 phòng mỗi tầng
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 64, // Tổng 8 tầng * 8 phòng
      itemBuilder: (context, index) {
        int floor = index ~/ 8 + 2;
        int roomNumber = index % 8 + 1;
        String roomName = '${roomTypes[floor % 3]} Room $floor-$roomNumber';
        double roomPrice = roomPrices[floor % 3];

        bool isSelected = selectedRooms.containsKey(roomName);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedRooms.remove(roomName);
              } else {
                selectedRooms[roomName] = {
                  'price': roomPrice,
                  'quantity': 1,
                  'type': roomTypes[floor % 3]
                };
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    roomName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${roomPrice.toStringAsFixed(2)} USD',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPaymentBox() {
    Map<String, String> price = {
      'DDR': '100 USD',
      'EDR': '150 USD',
      'JSD': '200 USD'
    };
    Map<String, List<String>> groupedRooms = {};

    // Nhóm các phòng theo loại
    selectedRooms.forEach((roomName, details) {
      String roomType = details['type'];
      if (!groupedRooms.containsKey(roomType)) {
        groupedRooms[roomType] = [];
      }
      groupedRooms[roomType]!.add(roomName);
    });

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16),
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Rooms:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...groupedRooms.entries.map((entry) {
                  String roomType = entry.key;
                  List<String> rooms = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '$roomType-${price[roomType]}: ${rooms.join(", ")}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Check-in:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${checkInDate!.toLocal()}".split(' ')[0],
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, true),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Check-out:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${checkOutDate!.toLocal()}".split(' ')[0],
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, false),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${calculateTotalPrice().toStringAsFixed(2)} USD',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Booking'),
                  content: const Text(
                      'Are you sure you want to confirm the booking?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Đóng hộp thoại khi khách chọn "No"
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Hiển thị thông báo đặt phòng thành công và chuyển trang
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking confirmed! Thank you.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.of(context).pop(); // Đóng hộp thoại
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerHomePage(
                              email: widget.email,
                              password: widget.password,
                            ),
                          ),
                          (route) => false,
                        ); //đóng booking page
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Confirm Booking'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        actions: <Widget>[
          // Các nút điều hướng

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingHistory(
                    email: widget.email,
                    password: widget.password,
                  ),
                ),
              );
            },
            child: const Text(
              'HISTORY',
              style: TextStyle(color: Color(0xFFFFFFF0)),
            ),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 3, 33, 22),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildRoomGrid(),
            ),
          ),
          if (selectedRooms.isNotEmpty) buildPaymentBox(),
        ],
      ),
    );
  }
}
