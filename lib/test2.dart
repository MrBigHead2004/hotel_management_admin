import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Demo',
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Web App"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          // Kiểm tra nếu kích thước chiều ngang của cửa sổ nhỏ hơn giá trị tối thiểu
          if (width < 800) {
            // Đặt kích thước tối thiểu cho chiều ngang
            width = 800;
          }

          if (height < 400) {
            // Đặt kích thước tối thiểu cho chiều cao
            height = 400;
          }

          // Trả về widget với kích thước đã được điều chỉnh
          return Center(
            child: Container(
              width: width,
              height: height,
              color: Colors.blue,
              child: const SizedBox(
                height: 400,
                child: Text(
                  "dnkfnkdajskfnadsnkjfkrewjfkjewjfkjejfkrejfkjkerjwfjrkejfkjrjfk",
                  style: TextStyle(fontSize: 50),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


// FloatingActionButton(
            //   heroTag: 'uniqueTag1',
            //   onPressed: () {
            //     _scrollController.animateTo(0,
            //         duration: const Duration(seconds: 1),
            //         curve: Curves.easeInOut);
            //   },
            //   backgroundColor: Colors.white, // Màu của nút cuộn lên trên
            //   child: const Icon(Icons.arrow_upward),
            // ),