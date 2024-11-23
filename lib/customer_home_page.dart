import 'package:flutter/material.dart';
import 'package:flutter_2/booking_history.dart';
import 'package:flutter_2/booking_page.dart';
import 'package:flutter_2/room_details.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key, required this.email, required this.phone});
  final String email;
  final String phone;
  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          //leading: null,
          //leading: kIsWeb ? null : const BackButton(),
          title: const Text(
            'WELCOME TO HOTEL IT3080',
            style: TextStyle(color: Color(0xFFFFFFF0)),
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
                      phone: widget.phone,
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
          backgroundColor: const Color.fromARGB(255, 3, 33, 22),
        ),
        body: ListView(children: [
          Column(
            children: [
              const Text(
                'Rooms & Suites',
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  height: 1080,
                  width: 1360,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/image/DeluxeDoubleRoom.png', // Đường dẫn tới hình ảnh
                              width: 400, // Đặt kích thước tùy ý
                              height: 300,
                              fit: BoxFit.cover, // Cách hiển thị hình ảnh
                            ),
                            const Text(
                              'Deluxe double or twin room',
                              style: TextStyle(color: Color(0xFFFFFFF0)),
                            ),
                            SizedBox(
                              width: 400,
                              child: Row(
                                children: [
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 3, 33, 22),
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
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFFFFFFF0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    height: 60,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailsPage(
                                                    email: widget.email,
                                                    phone: widget.phone,
                                                    type: 'Deluxe',
                                                  )),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          // Hình dạng nút
                                          borderRadius: BorderRadius
                                              .zero, // Bo tròn bằng 0 để tạo hình chữ nhật
                                        ),
                                        side: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 3, 33, 22),
                                            width: 1),
                                      ),
                                      child: const Text(
                                        'Details',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 3, 33, 22)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/image/ExecutiveDoubleRoom.png', // Đường dẫn tới hình ảnh
                              width: 400, // Đặt kích thước tùy ý
                              height: 300,
                              fit: BoxFit.cover, // Cách hiển thị hình ảnh
                            ),
                            const Text(
                              'Executive double or twin room',
                              style: TextStyle(color: Color(0xFFFFFFF0)),
                            ),
                            SizedBox(
                              width: 400,
                              child: Row(
                                children: [
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 3, 33, 22),
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
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFFFFFFF0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    height: 60,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailsPage(
                                                    type: 'Executive',
                                                    email: widget.email,
                                                    phone: widget.phone,
                                                  )),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          // Hình dạng nút
                                          borderRadius: BorderRadius
                                              .zero, // Bo tròn bằng 0 để tạo hình chữ nhật
                                        ),
                                        side: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 3, 33, 22),
                                            width: 1),
                                      ),
                                      child: const Text(
                                        'Details',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 3, 33, 22)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/image/JuniorSuiteDouble.png', // Đường dẫn tới hình ảnh
                              width: 400, // Đặt kích thước tùy ý
                              height: 300,
                              fit: BoxFit.cover, // Cách hiển thị hình ảnh
                            ),
                            const Text(
                              'Junior Suite Double',
                              style: TextStyle(color: Color(0xFFFFFFF0)),
                            ),
                            SizedBox(
                              width: 400,
                              child: Row(
                                children: [
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 3, 33, 22),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BookingPage(
                                                    email: widget.email,
                                                    phone: widget.phone,
                                                  )),
                                        );
                                      },
                                      child: const Text(
                                        'Book now',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    height: 60,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailsPage(
                                                    type: 'Junior',
                                                    email: widget.email,
                                                    phone: widget.phone,
                                                  )),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          // Hình dạng nút
                                          borderRadius: BorderRadius
                                              .zero, // Bo tròn bằng 0 để tạo hình chữ nhật
                                        ),
                                        side: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 3, 33, 22),
                                            width: 1),
                                      ),
                                      child: const Text(
                                        'Details',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 3, 33, 22)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingHistory(
                  email: widget.email,
                  phone: widget.phone,
                ),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 3, 33, 22),
          child: const Icon(Icons.history),
        ));
  }
}
