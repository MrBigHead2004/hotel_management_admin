import 'package:flutter/material.dart';
import 'package:flutter_2/customer_home_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.email, required this.phone});
  final String email;
  final String phone;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Map<String, Map<String, dynamic>> selectedRooms = {};

  // Biến lưu trữ ngày Check-in và Check-out
  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now();
    checkOutDate = checkInDate!.add(const Duration(days: 1));
  }

  void selectRoom(String roomName, String price, int quantity) {
    setState(() {
      if (quantity > 0) {
        selectedRooms[roomName] = {'price': price, 'quantity': quantity};
      } else {
        selectedRooms.remove(roomName);
      }
    });
  }

  double calculateTotalPrice() {
    double total = 0.0;

    if (checkInDate != null && checkOutDate != null) {
      // Tính số ngày giữa Check-in và Check-out
      int numNights = checkOutDate!.difference(checkInDate!).inDays;

      selectedRooms.forEach((_, details) {
        double roomPrice =
            double.parse(details['price'].toString().split(' ')[0]);
        int quantity = details['quantity'];
        // Cộng tiền cho từng loại phòng
        total += roomPrice * numNights * quantity - 10 * (numNights - 1);
      });
    }
    return total;
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

          // Cập nhật Check-out Date mặc định nếu cần
          if (checkOutDate == null || checkOutDate!.isBefore(checkInDate!)) {
            checkOutDate = checkInDate!.add(const Duration(days: 1));
          }
        } else {
          // Đảm bảo Check-out lớn hơn Check-in
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Rooms"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(height: 16),
              buildRoomCard(
                context,
                image: 'assets/image/DeluxeDoubleRoom.png',
                roomName: 'Deluxe Double Room',
                price: '100 USD',
              ),
              buildRoomCard(
                context,
                image: 'assets/image/ExecutiveDoubleRoom.png',
                roomName: 'Executive Double Room',
                price: '150 USD',
              ),
              buildRoomCard(
                context,
                image: 'assets/image/JuniorSuiteDouble.png',
                roomName: 'Junior Suite Double',
                price: '200 USD',
              ),
              const SizedBox(height: 100),
            ],
          ),
          if (selectedRooms.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildPaymentBox(),
            ),
        ],
      ),
    );
  }

  Widget buildRoomCard(BuildContext context,
      {required String image,
      required String roomName,
      required String price}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 150,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roomName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Price: $price',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          buildQuantitySelector(roomName, price),
        ],
      ),
    );
  }

  Widget buildQuantitySelector(String roomName, String price) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            int currentQuantity = selectedRooms[roomName]?['quantity'] ?? 0;
            if (currentQuantity > 0) {
              selectRoom(roomName, price, currentQuantity - 1);
            }
          },
        ),
        Text(
          selectedRooms[roomName]?['quantity']?.toString() ?? '0',
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            int currentQuantity = selectedRooms[roomName]?['quantity'] ?? 0;
            selectRoom(roomName, price, currentQuantity + 1);
          },
        ),
      ],
    );
  }

  Widget buildPaymentBox() {
    void showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Your Booking'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Booking Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...selectedRooms.entries.map((entry) {
                  String roomName = entry.key;
                  Map<String, dynamic> details = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '- $roomName: ${details['quantity']} room(s), ${details['price']} each',
                    ),
                  );
                }).toList(),
                const SizedBox(height: 8),
                Text(
                    'Check-in: ${checkInDate != null ? "${checkInDate!.toLocal()}".split(' ')[0] : 'Not selected'}'),
                Text(
                    'Check-out: ${checkOutDate != null ? "${checkOutDate!.toLocal()}".split(' ')[0] : 'Not selected'}'),
                const SizedBox(height: 8),
                Text(
                  'Total Price: ${calculateTotalPrice().toStringAsFixed(2)} USD',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại

                  // Xử lý thanh toán hoặc chuyển đến bước tiếp theo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Payment confirmed! Thank you for your booking.'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          CustomerHomePage(
                        email: widget.email,
                        phone: widget.phone,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

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
                ...selectedRooms.entries.map((entry) {
                  String roomName = entry.key;
                  Map<String, dynamic> details = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '$roomName - ${details['quantity']} room(s) - ${details['price']} each',
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
            onPressed: () => showConfirmationDialog(context),
            child: Text('Proceed payment'))
      ],
    );
  }
}
