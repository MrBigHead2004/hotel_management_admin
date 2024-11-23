import 'package:flutter/material.dart';
import 'package:flutter_2/booking_page.dart';
import 'package:flutter_2/customer_home_page.dart';

class DetailsPage extends StatefulWidget {
  final String type;
  final String email;
  final String phone;
  const DetailsPage(
      {super.key,
      required this.type,
      required this.email,
      required this.phone});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    String impath;
    String details = 'details for now';
    if (widget.type == "Deluxe") {
      impath = 'assets/image/DeluxeDoubleRoom.png';
      details = 'details for now';
    } else if (widget.type == "Executive") {
      impath = 'assets/image/ExecutiveDoubleRoom.png';
      details = 'details for now';
    } else {
      impath = 'assets/image/JuniorSuiteDouble.png';
      details = 'details for now';
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontSize: 32, color: Color(0xFFFFFFF0)),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 33, 22),
        actions: <Widget>[
          // Các nút điều hướng
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerHomePage(
                    email: widget.email,
                    phone: widget.phone,
                  ),
                ),
              );
            },
            child: const Text(
              'HOME',
              style: TextStyle(color: Color(0xFFFFFFF0)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerHomePage(
                    email: widget.email,
                    phone: widget.phone,
                  ),
                ),
              );
            },
            child: const Text(
              'HOME',
              style: TextStyle(color: Color(0xFFFFFFF0)),
            ),
          )
        ],
      ),
      body: Row(
        children: [
          const SizedBox(
            width: 100,
          ),
          Image.asset(
            impath, // Đường dẫn tới hình ảnh
            width: 600, // Đặt kích thước tùy ý
            height: 600,
            fit: BoxFit.cover, // Cách hiển thị hình ảnh
          ),
          const SizedBox(
            width: 100,
          ),
          Column(
            children: [
              SizedBox(
                height: 600,
                child: Text(details,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 3, 33, 22), fontSize: 20)),
              ),
              SizedBox(
                width: 200,
                height: 60,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      // Hình dạng nút
                      borderRadius: BorderRadius
                          .zero, // Bo tròn bằng 0 để tạo hình chữ nhật
                    ),
                    backgroundColor: const Color.fromARGB(255, 3, 33, 22),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(
                          email: widget.email,
                          phone: widget.phone,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Book now',
                    style: TextStyle(fontSize: 20, color: Color(0xFFFFFFF0)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
