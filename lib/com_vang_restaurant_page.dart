import 'package:flutter/material.dart';
import 'package:flutter_2/booking_history.dart';
import 'package:flutter_2/booking_page.dart';
import 'package:flutter_2/customer_home_page.dart';
import 'package:flutter_2/garden_longe_bar_page.dart';

class ComVangRestaurantPage extends StatefulWidget {
  const ComVangRestaurantPage(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  State<ComVangRestaurantPage> createState() => _ComVangRestaurantPageState();
}

class _ComVangRestaurantPageState extends State<ComVangRestaurantPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: true,
          title: const Text(
            'HOTEL IT3080',
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
                    builder: (context) => BookingPage(
                      email: widget.email,
                      password: widget.password,
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
                  'assets/image/Com-Vang-Restaurant-3.jpg',
                  height: 1080, // Đường dẫn tới hình ảnh
                ),
                const Column(
                  children: [
                    SizedBox(
                      height: 500,
                    ),
                    Center(
                      child: Text(
                        'Cốm Vàng restaurant',
                        style: TextStyle(
                            color: Colors.white, // Màu chữ
                            fontSize: 60, // Kích thước chữ
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic // Đậm
                            ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 100),
            Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 6,
                      child: SizedBox(
                        width: 200,
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding:
                            const EdgeInsets.all(16.0), // Khoảng cách bên trong
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 245, 242, 242), // Màu nền
                          borderRadius: BorderRadius.zero, // Góc bo tròn
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Bóng mờ
                              blurRadius: 5.0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 600,
                        width: 240,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Opening hour',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              '10:00 AM TO 10:10 PM',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 22),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Divider(
                              color: Colors.black, // Màu sắc của đường kẻ
                              thickness: 0.5, // Độ dày của đường kẻ
                              indent: 20, // Lùi vào từ bên trái
                              endIndent: 20, // Lùi vào từ bên phải
                            ),
                            const SizedBox(height: 20),
                            const Icon(
                              Icons.phone,
                              size: 40,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '+84 852236541',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(height: 20),
                            const Icon(
                              Icons.email,
                              size: 40,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'info@Myhotel.com',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(height: 20),
                            const Divider(
                              color: Colors.black, // Màu sắc của đường kẻ
                              thickness: 0.5, // Độ dày của đường kẻ
                              indent: 20, // Lùi vào từ bên trái
                              endIndent: 20, // Lùi vào từ bên phải
                            ),
                            const SizedBox(height: 20),
                            Flexible(
                              child: Container(
                                width: 160, // Chiều rộng khung
                                height: 40, // Chiều cao khung
                                decoration: BoxDecoration(
                                  color: Colors.grey[200], // Màu nền khung
                                  borderRadius:
                                      BorderRadius.zero, // Bo góc khung
                                  border: Border.all(
                                    color: Colors.black, // Màu viền
                                    width: 1, // Độ dày viền
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        List<String> images = [
                                          'assets/image/menu_1.png',
                                          'assets/image/menu_2.png',
                                          'assets/image/menu_3.png',
                                        ]; // Danh sách ảnh
                                        PageController pageController =
                                            PageController();
                                        ValueNotifier<int> currentPageNotifier =
                                            ValueNotifier<int>(0);

                                        pageController.addListener(() {
                                          currentPageNotifier.value =
                                              pageController.page!.round();
                                        });
                                        double screenHeight =
                                            MediaQuery.of(context).size.height;
                                        double screenWidth =
                                            MediaQuery.of(context).size.width;
                                        return Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: screenHeight *
                                                    0.82, // Chiều cao ảnh
                                                width: screenWidth *
                                                    0.63, // Chiều rộng ảnh
                                                child: PageView.builder(
                                                  controller: pageController,
                                                  itemCount: images.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Image.asset(
                                                      images[index],
                                                      fit: BoxFit
                                                          .cover, // Tự động co dãn ảnh cho phù hợp
                                                    );
                                                  },
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.arrow_back),
                                                    onPressed: () {
                                                      if (pageController.page! >
                                                          0) {
                                                        pageController
                                                            .previousPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve:
                                                              Curves.easeInOut,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  ValueListenableBuilder<int>(
                                                    valueListenable:
                                                        currentPageNotifier,
                                                    builder: (context,
                                                        currentPage, child) {
                                                      return Text(
                                                        'Page ${currentPage + 1} of ${images.length}',
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.arrow_forward),
                                                    onPressed: () {
                                                      if (pageController.page! <
                                                          images.length - 1) {
                                                        pageController.nextPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve:
                                                              Curves.easeInOut,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Close'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'View menu ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              child: Container(
                                width: 160, // Chiều rộng khung
                                height: 40, // Chiều cao khung
                                decoration: BoxDecoration(
                                  color: Colors.grey[200], // Màu nền khung
                                  borderRadius:
                                      BorderRadius.zero, // Bo góc khung
                                  border: Border.all(
                                    color: Colors.black, // Màu viền
                                    width: 1, // Độ dày viền
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Thao tác khi nhấn nút
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Website',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              child: Container(
                                width: 160, // Chiều rộng khung
                                height: 40, // Chiều cao khung
                                decoration: BoxDecoration(
                                  color: Colors.black, // Màu nền khung
                                  borderRadius:
                                      BorderRadius.zero, // Bo góc khung
                                  border: Border.all(
                                    color: Colors.black, // Màu viền
                                    width: 1, // Độ dày viền
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Thao tác khi nhấn nút
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Book table',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 20,
                      ),
                    ),
                    Expanded(
                      flex: 24,
                      child: Image.asset(
                        'assets/image/Com-Vang-Restaurant.jpg',
                        width: 900, // Đặt kích thước tùy ý
                        height: 600,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Expanded(
                      flex: 6,
                      child: SizedBox(
                        width: 200,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        width: 200,
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: SizedBox(
                        width: 200,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 20,
                      ),
                    ),
                    Expanded(
                      flex: 24,
                      child: Text(
                        'Embark on a Culinary Journey at Com Vang Restaurant.Located on the 9th floor of the opulent Gloud Hotel, Com Vang Restaurant beckons discerning diners with an exquisite and serene dining experience.Immerse yourself in the symphony of traditional Vietnamese cuisine, meticulously crafted into set menus that showcase Vietnam culinary artistry and vibrant flavors.Com Vang Restaurant is a haven for those seeking an authentic Vietnamese dining adventure.Each set menu is a carefully curated collection of dishes, designed to tantalize the taste buds and transport you on a culinary journey through the diverse regions of Vietnam.Indulge in an array of delectable specialties, from the delicate freshness of spring rolls to the hearty richness of slow-cooked stews, all prepared with the finest local ingredients and seasoned to perfection.Com Vang Restaurants ambiance is as captivating as its cuisine, with elegant décor and panoramic city views that set the stage for an unforgettable dining experience.\n\nStep into Com Vang Restaurant and discover the true essence of Vietnamese cuisine, where tradition meets innovation and every bite is a symphony of flavors.Com Vang Restaurant - A culinary haven where Vietnamese flavors come alive.',
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        width: 200,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              height: 880,
              color: Colors.grey[100], // Màu nền của toàn bộ màn hình
              child: Center(
                child: Container(
                  width: 560, // Rộng ngang với ảnh
                  padding: const EdgeInsets.all(
                      16), // Khoảng cách giữa viền và nội dung
                  decoration: const BoxDecoration(
                    color: Colors.white, // Màu nền của container nổi bật
                    borderRadius: BorderRadius.zero, // Góc bo tròn
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'You might be interested with',
                        style: TextStyle(fontSize: 40),
                      ),
                      Image.asset(
                        'assets/image/Garden-Lounge-Bar-2.jpg',
                        height: 360,
                        width: 560, // Đường dẫn tới hình ảnh
                      ),
                      const Text(
                        'Garden Lounge',
                        style: TextStyle(fontSize: 40),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'The bar is a year-round beer bar that is thoroughly dedicated to providing customers with the perfect draft to enjoy their drink moment of the day. The bar offers different types of Craft Beer,delivering rich and irresistible flavor.',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.start, // Canh giữa văn bản
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Opening hour',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '10:00 AM TO 11:30 PM',
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        color: Colors.black, // Màu sắc của đường kẻ
                        thickness: 0.5, // Độ dày của đường kẻ
                        indent: 20, // Lùi vào từ bên trái
                        endIndent: 20, // Lùi vào từ bên phải
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 160, // Chiều rộng khung
                        height: 40, // Chiều cao khung
                        decoration: BoxDecoration(
                          color: Colors.white, // Màu nền khung
                          borderRadius: BorderRadius.zero, // Bo góc khung
                          border: Border.all(
                            color: Colors.black, // Màu viền
                            width: 1, // Độ dày viền
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GardenLongeBarPage(
                                        email: widget.email,
                                        password: widget.password,
                                      )),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View details ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
