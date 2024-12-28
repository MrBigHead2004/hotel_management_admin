import 'package:flutter/material.dart';
import 'package:flutter_2/customer/booking_history.dart';
import 'package:flutter_2/customer/booking_page.dart';
import 'package:flutter_2/customer/com_vang_restaurant_page.dart';
import 'package:flutter_2/customer/customer_login_page.dart';
import 'package:flutter_2/customer/garden_longe_bar_page.dart';
import 'package:flutter_2/customer/room_details.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage(
      {super.key,
      required this.cusid,
      required this.password,
      required this.username});
  final String username;
  final String password;
  final int cusid;
  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final ScrollController _scrollController = ScrollController();
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
                  // Hiển thị hộp thoại xác nhận trước khi đăng xuất
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        content:
                            const Text('Are you sure you want to sign out?'),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.check,
                                color: Colors.green), // Icon check
                            onPressed: () {
                              // Nếu người dùng chọn "YES", thực hiện đăng xuất
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomerLoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red), // Icon close
                            onPressed: () {
                              // Nếu người dùng chọn "NO", đóng hộp thoại
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.exit_to_app, // Icon đăng xuất
                  color: Color(0xfffffff0),
                  size: 24, // Kích thước biểu tượng
                ),
              )),
          actions: <Widget>[
            // Các nút điều hướng
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPage(
                      cusid: widget.cusid,
                      password: widget.password,
                      username: widget.username,
                    ),
                  ),
                );
              },
              child: const Text(
                'BOOK',
                style: TextStyle(color: Color(0xFFFFFFF0)),
              ),
            ),
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
                style: TextStyle(color: Color(0xFFFFFFF0)),
              ),
            )
          ],
          backgroundColor: const Color.fromARGB(255, 3, 33, 22),
        ),
        body: ListView(
            shrinkWrap: true,
            controller: _scrollController,
            children: [
              const SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  Image.asset(
                    'assets/image/hotel_login_image.jpg', // Đường dẫn tới hình ảnh
                  ),
                  const Column(
                    children: [
                      SizedBox(
                        height: 500,
                      ),
                      Center(
                        child: Text(
                          'Welcome to IT3180 hotel',
                          style: TextStyle(
                            color: Colors.white, // Màu chữ
                            fontSize: 45, // Kích thước chữ
                            fontWeight: FontWeight.bold, // Đậm
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/image/DeluxeDouble.png', // Đường dẫn tới hình ảnh
                                width: 400, // Đặt kích thước tùy ý
                                height: 300,
                                fit: BoxFit.cover, // Cách hiển thị hình ảnh
                              ),
                              const Text(
                                'Deluxe Double',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 3, 33, 22),
                                    fontSize: 20),
                              ),
                              SizedBox(
                                width: 400,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
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
                                                builder: (context) =>
                                                    BookingPage(
                                                      password: widget.password,
                                                      username: widget.username,
                                                      cusid: widget.cusid,
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
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsPage(
                                                      password: widget.password,
                                                      username: widget.username,
                                                      type: 'DeluxeDouble',
                                                      cusid: widget.cusid,
                                                    )),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .zero, // Bo tròn bằng 0 để tạo hình chữ nhật
                                          ),
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 3, 33, 22),
                                              width: 1),
                                        ),
                                        child: const Text(
                                          'Details',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 3, 33, 22)),
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
                                'assets/image/ExecutiveDouble.png', // Đường dẫn tới hình ảnh
                                width: 400, // Đặt kích thước tùy ý
                                height: 300,
                                fit: BoxFit.cover, // Cách hiển thị hình ảnh
                              ),
                              const Text(
                                'Executive Double',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 3, 33, 22),
                                    fontSize: 20),
                              ),
                              SizedBox(
                                width: 400,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
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
                                                builder: (context) =>
                                                    BookingPage(
                                                      password: widget.password,
                                                      username: widget.username,
                                                      cusid: widget.cusid,
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
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsPage(
                                                      password: widget.password,
                                                      username: widget.username,
                                                      type: 'ExecutiveDouble',
                                                      cusid: widget.cusid,
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
                                              color: Color.fromARGB(
                                                  255, 3, 33, 22),
                                              width: 1),
                                        ),
                                        child: const Text(
                                          'Details',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 3, 33, 22)),
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
                                style: TextStyle(
                                    color: Color.fromARGB(255, 3, 33, 22),
                                    fontSize: 20),
                              ),
                              SizedBox(
                                width: 400,
                                child: Row(
                                  children: [
                                    Expanded(
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
                                                builder: (context) =>
                                                    BookingPage(
                                                      password: widget.password,
                                                      username: widget.username,
                                                      cusid: widget.cusid,
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
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsPage(
                                                      password: widget.password,
                                                      username: widget.username,
                                                      type: 'JuniorSuiteDouble',
                                                      cusid: widget.cusid,
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
                                              color: Color.fromARGB(
                                                  255, 3, 33, 22),
                                              width: 1),
                                        ),
                                        child: const Text(
                                          'Details',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 3, 33, 22)),
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
                  const SizedBox(
                    height: 200,
                  ),
                ],
              ),
              Column(
                children: [
                  const Opacity(
                    opacity: 0.5,
                    child: Text(
                      'Discover',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Text(
                    'Hotel Services',
                    style: TextStyle(fontSize: 40),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Image.asset(
                            'assets/image/Com-Vang-Restaurant.jpg',
                            width: 800, // Đặt kích thước tùy ý
                            height: 600,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(
                                  8.0), // Khoảng cách ngoài khung
                              padding: const EdgeInsets.all(
                                  16.0), // Khoảng cách trong khung
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 186, 180, 180),
                                    width: 1), // Viền mỏng màu vàng
                                borderRadius: BorderRadius.zero, // Không bo góc
                                // Màu nền
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // Kích thước khung vừa đủ
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // Căn trái
                                    children: [
                                      const Text(
                                        "Cốm Vàng Restaurant",
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromARGB(255, 3, 33, 22),
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // Khoảng cách giữa các dòng
                                      const Text(
                                        "Embark on a Culinary Journey at Com Vang Restaurant. \nLocated on the 9th floor of the opulent Gloud Hotel, \nCom Vang Restaurant beckons discerning diners with \nan exquisite and serene dining experience. Immerse \nyourself in the symphony of traditional Vietnamese \ncuisine, meticulously crafted into set menus that \nshowcase Vietnam's culinary artistry and vibrant \nflavors.",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 16), // Khoảng cách trước nút
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ComVangRestaurantPage(
                                                      password: widget.password,
                                                      username: widget.username,
                                                      cusid: widget.cusid,
                                                    )),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255,
                                              211,
                                              167,
                                              33), // Nền màu vàng
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .zero, // Không bo góc (hình chữ nhật)
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical:
                                                  12), // Điều chỉnh padding để tạo không gian
                                        ),
                                        child: const Text(
                                          'More details',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors
                                                .white, // Chữ màu trắng để nổi bật trên nền vàng
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.all(
                                8.0), // Khoảng cách ngoài khung
                            padding: const EdgeInsets.all(
                                16.0), // Khoảng cách trong khung
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 186, 180, 180),
                                  width: 1), // Viền mỏng màu vàng
                              borderRadius: BorderRadius.zero, // Không bo góc
                              // Màu nền
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Kích thước khung vừa đủ
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // Căn trái
                                  children: [
                                    const Text(
                                      "Garden Lounge Bar",
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Color.fromARGB(255, 3, 33, 22),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 8), // Khoảng cách giữa các dòng
                                    const Text(
                                      "The bar is a year-round beer bar that is \nthoroughly dedicated to providing customers \nwith the perfect draft to enjoy their drink \nmoment of the day.",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 16), // Khoảng cách trước nút
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GardenLongeBarPage(
                                                    password: widget.password,
                                                    username: widget.username,
                                                    cusid: widget.cusid,
                                                  )),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 211, 167, 33), // Nền màu vàng
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius
                                              .zero, // Không bo góc (hình chữ nhật)
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical:
                                                12), // Điều chỉnh padding để tạo không gian
                                      ),
                                      child: const Text(
                                        'More details',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors
                                              .white, // Chữ màu trắng để nổi bật trên nền vàng
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          'assets/image/Garden-Lounge-Bar.jpg',
                          width: 800, // Đặt kích thước tùy ý
                          height: 600,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          'assets/image/Gloud-Spa.jpg',
                          width: 800, // Đặt kích thước tùy ý
                          height: 600,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.all(
                                8.0), // Khoảng cách ngoài khung
                            padding: const EdgeInsets.all(
                                16.0), // Khoảng cách trong khung
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 186, 180, 180),
                                  width: 1), // Viền mỏng màu vàng
                              borderRadius: BorderRadius.zero, // Không bo góc
                              // Màu nền
                            ),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Kích thước khung vừa đủ
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // Căn trái
                                  children: [
                                    Text(
                                      "Gloud Spa",
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Color.fromARGB(255, 3, 33, 22),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 8), // Khoảng cách giữa các dòng
                                    Text(
                                      "A peaceful space in the hotel where you can find the \npurity of Gloud Hotel",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Comming soon',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ) // Khoảng cách trước nút
                                  ],
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.all(
                                8.0), // Khoảng cách ngoài khung
                            padding: const EdgeInsets.all(
                                16.0), // Khoảng cách trong khung
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 186, 180, 180),
                                  width: 1), // Viền mỏng màu vàng
                              borderRadius: BorderRadius.zero, // Không bo góc
                              // Màu nền
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Kích thước khung vừa đủ
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // Căn trái
                                  children: [
                                    const Text(
                                      "Transfer services",
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Color.fromARGB(255, 3, 33, 22),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 8), // Khoảng cách giữa các dòng
                                    const Text(
                                      "We provide 24 hours airport transfers. Our aim is \nto offer the best reliable and safest transfers \nservice to all our customers at a competitive\nprice.",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 16), // Khoảng cách trước nút
                                    TextButton(
                                      onPressed: () {
                                        // Chức năng chuyển hướng
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 211, 167, 33), // Nền màu vàng
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius
                                              .zero, // Không bo góc (hình chữ nhật)
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical:
                                                12), // Điều chỉnh padding để tạo không gian
                                      ),
                                      child: const Text(
                                        'Direction',
                                        // nút chưa có tác dụng gì
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors
                                              .white, // Chữ màu trắng để nổi bật trên nền vàng
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          'assets/image/Transfer.jpg',
                          width: 800, // Đặt kích thước tùy ý
                          height: 600,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ]),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Đặt nút ở góc bên trái
          children: [
            const SizedBox(
              width: 40,
            ), // Khoảng cách giữa các nút
            FloatingActionButton(
              heroTag: 'uniqueTag1',
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut);
              },
              backgroundColor: Colors.white, // Màu của nút cuộn lên trên
              child: const Icon(Icons.arrow_upward),
            ),
          ],
        ));
  }
}
