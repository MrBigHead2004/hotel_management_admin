import 'package:flutter/material.dart';
import 'dart:convert'; // Để làm việc với JSON
import 'package:flutter/services.dart';
import 'package:flutter_2/customer/booking_history.dart';
import 'package:flutter_2/customer/customer_home_page.dart';
import 'package:http/http.dart' as http;

class BookingPage extends StatefulWidget {
  const BookingPage({
    super.key,
    required this.cusid,
    required this.password,
    required this.username,
  });

  final String username;
  final String password;
  final int cusid;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Map<String, Map<String, dynamic>> selectedRooms = {};
  DateTime? checkInDate;
  DateTime? checkOutDate;
  List<dynamic> bookings = [];
  List<dynamic> rooms = [];

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now();
    checkOutDate = checkInDate!.add(const Duration(days: 1));
    _loadData();
  }

  Future<void> _loadData() async {
    String emCre = 'theanh:123456';
    String baseCre = base64Encode(utf8.encode(emCre));
    String username = widget.username;
    String password = widget.password;
    String credentials = '$username:$password';
    String base64Credentials = base64Encode(utf8.encode(credentials));

    try {
      // Lấy dữ liệu phòng từ API
      final http.Response roomResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/rooms/'),
        headers: {
          'Authorization': 'Basic $base64Credentials',
          'Content-Type': 'application/json',
        },
      );

      // Lấy dữ liệu booking từ API
      final http.Response bookingResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/employees/bookings/allhistory/'),
        headers: {
          'Authorization': 'Basic $baseCre',
          'Content-Type': 'application/json',
        },
      );

      if (roomResponse.statusCode == 200 && bookingResponse.statusCode == 200) {
        final roomData = json.decode(roomResponse.body);
        final bookingData = json.decode(bookingResponse.body);

        setState(() {
          rooms = List.from(roomData)
            ..sort(
                (a, b) => a['name'].compareTo(b['name'])); // Sắp xếp theo name
          bookings = bookingData; // Gán bookings từ API
        });
      } else {
        throw Exception(
            'Lỗi tải dữ liệu từ API: ${roomResponse.statusCode}, ${bookingResponse.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi tải dữ liệu: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  bool isRoomAvailable(int roomName) {
    for (var booking in bookings) {
      if (booking['room'] == roomName) {
        DateTime bookingCheckInDate = DateTime.parse(booking['check_in_date']);
        DateTime bookingCheckOutDate =
            DateTime.parse(booking['check_out_date']);

        // Nếu trạng thái là 'Cancelled', phòng sẽ luôn có sẵn
        if (booking['status'] == 'Cancelled') {
          return true;
        }

        // Kiểm tra nếu phòng đã được đặt trong khoảng thời gian đã chọn
        if ((checkInDate!.isBefore(bookingCheckOutDate) &&
                checkOutDate!.isAfter(bookingCheckInDate)) ||
            (checkInDate!.isAtSameMomentAs(bookingCheckInDate) ||
                checkOutDate!.isAtSameMomentAs(bookingCheckOutDate))) {
          return false;
        }
      }
    }
    return true;
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
          selectedRooms.clear();
          if (checkOutDate == null || checkOutDate!.isBefore(checkInDate!)) {
            checkOutDate = checkInDate!.add(const Duration(days: 1));
          }
        } else {
          if (pickedDate.isAfter(checkInDate!)) {
            checkOutDate = pickedDate;
            selectedRooms.clear();
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
        double roomPrice = double.tryParse(details['price'].toString()) ?? 0.0;
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
            crossAxisCount: 8,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            var room = rooms[index];
            String roomName = room['name'];
            int roomId = room['id'];
            double roomPrice = double.tryParse(room['price']) ?? 0.0;
            int roomType = room['room_types'];
            String abbreviatedRoomType = ['DDR', 'EDR', 'JSD'][roomType - 1];

            bool isSelected = selectedRooms.containsKey(roomName);
            bool isAvailable = isRoomAvailable(roomId);

            return GestureDetector(
              onTap: () {
                if (isAvailable) {
                  setState(() {
                    if (isSelected) {
                      selectedRooms.remove(roomName);
                    } else {
                      selectedRooms[roomName] = {
                        'id': room['id'],
                        'price': roomPrice,
                        'type': roomType
                      };
                    }
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isAvailable
                      ? (isSelected ? Colors.green : Colors.grey[300])
                      : Colors.red[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    '$roomName\n$abbreviatedRoomType\$',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> postRoomBooking(Map<String, dynamic> roomDetails) async {
    String username = widget.username;
    String password = widget.password;

    // Mã hóa Basic Auth (username:password) thành Base64
    String credentials = '$username:$password';
    String base64Credentials = base64Encode(utf8.encode(credentials));
    // print(roomDetails['id']);
    // print(roomDetails['checkInDate']);
    // print(roomDetails['checkOutDate']);
    final url = Uri.parse(
        'http://127.0.0.1:8000/api/bookings/'); // Thay bằng URL của API của bạn

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $base64Credentials',
      },
      body: json.encode({
        'room': roomDetails['id'],
        'check_in_date': roomDetails['checkInDate'],
        'check_out_date': roomDetails['checkOutDate'],
        'status': "Confirmed",
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Nếu gọi API thành công
      print('Room booking successful for ${roomDetails['name']}');
    } else {
      // Nếu có lỗi
      print('Failed to book room for ${roomDetails['name']}');
    }
  }

  String formatDate(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    return '$year-$month-$day';
  }

  Widget buildPaymentBox() {
    // Nhóm các phòng theo loại (1, 2, 3 -> Single, Double, Suite)
    Map<String, Map<String, dynamic>> groupedRooms = {};
    selectedRooms.forEach((roomName, details) {
      int roomTypeCode = details['type']; // Lấy mã loại phòng (1, 2, 3)
      String roomType;

      // Ánh xạ số loại phòng thành tên loại phòng
      switch (roomTypeCode) {
        case 1:
          roomType = 'DoubleDeluxe';
          break;
        case 2:
          roomType = 'ExecutiveDeluxe';
          break;
        case 3:
          roomType = 'JuniorSuiteDouble';
          break;
        default:
          roomType = 'Unknown'; // Nếu có giá trị không xác định
      }

      // Thêm phòng vào nhóm theo loại
      if (!groupedRooms.containsKey(roomType)) {
        groupedRooms[roomType] = {};
      }
      groupedRooms[roomType]![roomName] = details;
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
                // Lặp qua từng nhóm phòng và hiển thị theo hàng
                ...groupedRooms.entries.map((groupEntry) {
                  String roomType = groupEntry.key;
                  Map<String, dynamic> rooms = groupEntry.value;

                  // Lấy giá phòng của nhóm
                  double roomPrice =
                      double.tryParse(rooms.values.first['price'].toString()) ??
                          0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị tên loại phòng và giá phòng
                      Row(
                        children: [
                          Text(
                            '$roomType rooms ',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${roomPrice.toStringAsFixed(2)} USD',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: rooms.entries.map((entry) {
                          String roomName = entry.key;
                          //var roomDetails = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Text(
                              roomName, // Hiển thị chỉ tên phòng
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
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
                      "${checkInDate?.toLocal() ?? ''}".split(' ')[0],
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
                      "${checkOutDate?.toLocal() ?? ''}".split(' ')[0],
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
              String formattedCheckInDate = formatDate(checkInDate!);
              String formattedCheckOutDate = formatDate(checkOutDate!);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Booking Confirmation'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          // Gửi yêu cầu API cho từng phòng đã chọn
                          for (var entry in selectedRooms.entries) {
                            //String roomName = entry.key;
                            var details = entry.value;

                            await postRoomBooking({
                              'id': details[
                                  'id'], // Truyền roomId thay vì roomName
                              'checkInDate': formattedCheckInDate,
                              'checkOutDate': formattedCheckOutDate,
                              'status': "Confirmed",
                            });
                          }

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerHomePage(
                                password: widget.password,
                                username: widget.username,
                                cusid: widget.cusid,
                              ),
                            ),
                            (route) => false,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Thank you for choosing our services!')),
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
                    content: Text('You haven\'t chosen any room yet :v'),
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
        title: const Text('Room booking'),
        actions: <Widget>[
          // Các nút điều hướng
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingHistory(
                    password: widget.password,
                    username: widget.username,
                    cusid: widget.cusid,
                  ),
                ),
              );
            },
            child: const Text(
              'HISTORY',
              style: TextStyle(color: Color.fromARGB(255, 3, 33, 22)),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          buildRoomGrid(),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Red rooms are not available in the chosen period!',
            style: TextStyle(color: Colors.red[300]),
            textAlign: TextAlign.center, // Căn giữa văn bản
          ),
          buildPaymentBox(),
        ],
      ),
    );
  }
}
