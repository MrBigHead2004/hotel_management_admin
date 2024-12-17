import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InfoScreen(),
    );
  }
}

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<dynamic> _data = []; // Danh sách dữ liệu từ API
  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> fetchData() async {
    final url = Uri.parse("http://10.13.47.160:8000/api/rooms/");

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final response = await http.get(url);

      // Log thông tin phản hồi từ API
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse JSON
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _data = data;
        });
      } else {
        setState(() {
          _errorMessage = "Không thể tải dữ liệu: ${response.statusCode}";
        });
      }
    } catch (error) {
      // Log lỗi nếu xảy ra exception
      print("Error: $error");

      setState(() {
        _errorMessage = "Có lỗi xảy ra: $error";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin API"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final item = _data[index];
                    return ListTile(
                      title: Text(item['name'] ?? "No Name"),
                      subtitle: Text(item['description'] ?? "No Description"),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
