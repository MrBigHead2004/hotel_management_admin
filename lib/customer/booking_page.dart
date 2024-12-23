import 'package:flutter/material.dart';
import 'dart:convert'; // Để làm việc với JSON
import 'package:flutter/services.dart';
import 'package:flutter_2/customer/booking_history.dart';
import 'package:flutter_2/customer/customer_home_page.dart'; // Để đọc file JSON

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.cusid});
  final int cusid;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Map<String, Map<String, dynamic>> selectedRooms = {};
  DateTime? checkInDate;
  DateTime? checkOutDate;
  List<dynamic> bookings = []; // Danh sách các booking từ file JSON
  List<dynamic> rooms = []; // Danh sách các phòng từ file JSON

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now();
    checkOutDate = checkInDate!.add(const Duration(days: 1));
    _loadData(); // Tải dữ liệu booking và phòng từ file JSON
  }

  // Hàm để đọc file booking.json và rooms.json
  Future<void> _loadData() async {
    final String roomResponse =
        await rootBundle.loadString('assets/data/room_to_book.json');
    final String bookingResponse =
        await rootBundle.loadString('assets/data/booking.json');

    final roomData = json.decode(roomResponse);
    final bookingData = json.decode(bookingResponse);

    setState(() {
      rooms = roomData;
      bookings = bookingData;
    });
  }

  // Kiểm tra phòng có trùng lịch không
  bool isRoomAvailable(String roomId) {
    for (var booking in bookings) {
      if (booking['room_id'] == roomId) {
        DateTime bookingCheckInDate = DateTime.parse(booking['check_in_date']);
        DateTime bookingCheckOutDate =
            DateTime.parse(booking['check_out_date']);
        // Kiểm tra xem lịch đặt có trùng không
        if ((checkInDate!.isBefore(bookingCheckOutDate) &&
                checkOutDate!.isAfter(bookingCheckInDate)) ||
            (checkInDate!.isAtSameMomentAs(bookingCheckInDate) ||
                checkOutDate!.isAtSameMomentAs(bookingCheckOutDate))) {
          return false; // Phòng không có sẵn
        }
      }
    }
    return true; // Phòng có sẵn
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
          // Khi thay đổi check-in, xóa các phòng đã chọn
          checkInDate = pickedDate;
          selectedRooms.clear(); // Xóa các phòng đã chọn trước đó
          if (checkOutDate == null || checkOutDate!.isBefore(checkInDate!)) {
            checkOutDate = checkInDate!.add(const Duration(days: 1));
          }
        } else {
          // Khi thay đổi check-out, xóa các phòng đã chọn
          if (pickedDate.isAfter(checkInDate!)) {
            checkOutDate = pickedDate;
            selectedRooms.clear(); // Xóa các phòng đã chọn trước đó
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
        int roomPrice = details['price'];
        total += roomPrice * numNights;
      });
    }
    return total;
  }

  Widget buildRoomGrid() {
    return Center(
      child: SizedBox(
        height: 520,
        width: 520,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8, // 8 phòng mỗi tầng
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: rooms.length, // Số lượng phòng từ JSON
          itemBuilder: (context, index) {
            var room = rooms[index];
            String roomId = room['room_id'];
            int roomPrice = room['price'];
            String roomType = room['room_type'];

            // Viết tắt tên các loại phòng
            String abbreviatedRoomType = '';
            if (roomType == 'DeluxeDouble') {
              abbreviatedRoomType = 'DDR';
            } else if (roomType == 'ExecutiveDouble') {
              abbreviatedRoomType = 'EDR';
            } else if (roomType == 'JuniorSuiteDouble') {
              abbreviatedRoomType = 'JSD';
            }

            bool isSelected = selectedRooms.containsKey(roomId);
            bool isAvailable = isRoomAvailable(roomId);

            return GestureDetector(
              onTap: () {
                if (isAvailable) {
                  setState(() {
                    if (isSelected) {
                      selectedRooms.remove(roomId);
                    } else {
                      selectedRooms[roomId] = {
                        'price': roomPrice,
                        'quantity': 1,
                        'type': room['room_type']
                      };
                    }
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isAvailable
                      ? (isSelected ? Colors.green : Colors.grey[300])
                      : Colors.red[200], // Nếu không có sẵn, sẽ hiển thị màu đỏ
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$roomId\n$abbreviatedRoomType-$roomPrice\$',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildPaymentBox() {
    Map<String, List<String>> groupedRooms = {};

    // Nhóm các phòng theo loại
    selectedRooms.forEach((roomId, details) {
      String roomType = details['type'];
      if (!groupedRooms.containsKey(roomType)) {
        groupedRooms[roomType] = [];
      }
      groupedRooms[roomType]!.add(roomId);
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
                  int prices = 0;
                  if (roomType == 'DeluxeDouble') {
                    prices = 100;
                  } else if (roomType == 'ExecutiveDouble') {
                    prices = 150;
                  } else {
                    prices = 200;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '$roomType-$prices USD  : ${rooms.join(", ")}',
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
            if (selectedRooms.isNotEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Booking Confirmation'),
                    content: const Text('Are you sure ?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerHomePage(
                                cusid: widget.cusid,
                              ),
                            ),
                            (route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Thanks you for choosing our services!')),
                          );
                        },
                        child: const Text('YES'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('NO'),
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    title: Text('Warning'),
                    content: Text('You havent chosen any room yet :v'),
                  );
                },
              );
            }
          },
          child: const Text('Confirm Booking'),
        ),
      ],
    );
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
                  builder: (context) => BookingHistory(
                    cusid: widget.cusid,
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
      body: ListView(
        children: [
          buildRoomGrid(),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Red rooms are not available during the period you selected',
            style: TextStyle(
              fontSize: 20,
              color: Colors.redAccent, // Màu đỏ nhạt
              fontStyle: FontStyle.italic, // Nghiêng chữ
            ),
            textAlign: TextAlign.center, // Căn giữa
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Picking the days before picking the rooms',
            style: TextStyle(
              fontSize: 20,
              color: Colors.redAccent, // Màu đỏ nhạt
              fontStyle: FontStyle.italic, // Nghiêng chữ
            ),
            textAlign: TextAlign.center, // Căn giữa
          ),
          const SizedBox(
            height: 10,
          ),
          buildPaymentBox(),
        ],
      ),
    );
  }
}