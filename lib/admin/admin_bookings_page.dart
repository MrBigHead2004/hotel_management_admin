import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_theme_notifier.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum CustomerType { registered, unregistered }

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String? selectedRoom;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  double totalAmount = 0.0;
  CustomerType selectedCustomerType = CustomerType.unregistered;
  String? userId;
  
  List<dynamic> rooms = [];
  List<dynamic> bookings = [];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String emCre = 'theanh:123456';
    String baseCre = base64Encode(utf8.encode(emCre));

    try {
      final http.Response roomResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/rooms/'),
        headers: {
          'Authorization': 'Basic $baseCre',
          'Content-Type': 'application/json',
        },
      );

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
            ..sort((a, b) => a['name'].compareTo(b['name']));
          bookings = bookingData;
        });
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  bool isRoomAvailable(int roomId) {
    if (checkInDate == null || checkOutDate == null) return true;

    for (var booking in bookings) {
      if (booking['room'] == roomId) {
        DateTime bookingCheckIn = DateTime.parse(booking['check_in_date']);
        DateTime bookingCheckOut = DateTime.parse(booking['check_out_date']);

        if (booking['status'] == 'Cancelled') {
          continue;
        }

        if ((checkInDate!.isBefore(bookingCheckOut) &&
            checkOutDate!.isAfter(bookingCheckIn)) ||
            (checkInDate!.isAtSameMomentAs(bookingCheckIn) ||
                checkOutDate!.isAtSameMomentAs(bookingCheckOut))) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;

          if (checkOutDate != null &&
              checkOutDate!.isBefore(picked.add(const Duration(days: 1)))) {
            checkOutDate = null;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Check-out date must be at least 1 day after check-in date!'),
                backgroundColor: Colors.black,
              ),
            );
          }
        } else {
          if (checkInDate != null &&
              picked.isBefore(checkInDate!.add(const Duration(days: 1)))) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Check-out date must be at least 1 day after check-in date!'),
                backgroundColor: Colors.black,
              ),
            );
          } else {
            checkOutDate = picked;
          }
        }
      });
    }
  }

  Future<void> registerCustomer() async {
    final String email = emailController.text;
    final String phone = phoneController.text;
    final String username = usernameController.text;
    final String password = passwordController.text;
    final String fullname = fullnameController.text;

    if (email.isNotEmpty &&
        phone.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty &&
        fullname.isNotEmpty) {
      final Map<String, String> userData = {
        'email': email,
        'phone_number': phone,
        'username': username,
        'password': password,
        'fullname': fullname,
      };

      try {
        final response = await http.post(
          Uri.parse("http://127.0.0.1:8000/users/register/"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        if (response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Customer Registration Successful')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration Failed: ${response.body}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  Future<void> confirmBooking() async {
    if (selectedRoom == null || checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select room and dates')),
      );
      return;
    }

    String emCre = 'theanh:123456';
    String baseCre = base64Encode(utf8.encode(emCre));

    final roomResponse = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/rooms/'),
      headers: {
        'Authorization': 'Basic $baseCre',
        'Content-Type': 'application/json',
      },
    );

    if (roomResponse.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get room information')),
      );
      return;
    }

    final List<dynamic> rooms = json.decode(roomResponse.body);
    final room = rooms.firstWhere(
      (room) => room['name'] == selectedRoom,
      orElse: () => null,
    );

    if (room == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room not found')),
      );
      return;
    }

    String formattedCheckIn = "${checkInDate!.year}-${checkInDate!.month}-${checkInDate!.day}";
    String formattedCheckOut = "${checkOutDate!.year}-${checkOutDate!.month}-${checkOutDate!.day}";

    final Map<String, dynamic> bookingData = {
      'room': room['id'],
      'check_in_date': formattedCheckIn,
      'check_out_date': formattedCheckOut,
      'status': "Confirmed",
    };

    if (selectedCustomerType == CustomerType.registered && userId != null) {
      bookingData['user_id'] = int.tryParse(userId!);
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/bookings/'),
        headers: {
          'Authorization': 'Basic $baseCre',
          'Content-Type': 'application/json',
        },
        body: json.encode(bookingData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking confirmed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            selectedRoom = null;
            checkInDate = null;
            checkOutDate = null;
            userId = null;
            emailController.clear();
            phoneController.clear();
            usernameController.clear();
            passwordController.clear();
            fullnameController.clear();
          });
        }
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating booking: $e')),
        );
      }
    }
  }

  Widget _buildCustomerInfoSection() {
    if (selectedCustomerType == CustomerType.registered) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer ID',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: defaultPadding),
          BookingInputField(
            hintText: 'Enter Customer ID',
            icon: const Icon(Icons.person),
            onChanged: (value) {
              setState(() {
                userId = value;
              });
            },
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer information',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: defaultPadding),
          BookingInputField(
            controller: fullnameController,
            hintText: 'Full Name',
            icon: const Icon(Icons.person),
          ),
          const SizedBox(height: defaultPadding),
          BookingInputField(
            controller: phoneController,
            hintText: 'Phone Number',
            icon: const Icon(Icons.phone),
            typeOfKeyboard: TextInputType.phone,
          ),
          const SizedBox(height: defaultPadding),
          BookingInputField(
            controller: emailController,
            hintText: 'Email',
            icon: const Icon(Icons.email_rounded),
            typeOfKeyboard: TextInputType.emailAddress,
          ),
          const SizedBox(height: defaultPadding),
          BookingInputField(
            controller: usernameController,
            hintText: 'Username',
            icon: const Icon(Icons.account_circle),
          ),
          const SizedBox(height: defaultPadding),
          BookingInputField(
            controller: passwordController,
            hintText: 'Password',
            icon: const Icon(Icons.lock),
            obscureText: true,
          ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: registerCustomer,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('Register Customer', 
                style: TextStyle(color: Colors.white)
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultCornerRadius - defaultPadding),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(defaultPadding * 2),
                decoration: BoxDecoration(
                  color: themeNotifier.isDarkMode
                      ? darkSecondaryBgColor
                      : Colors.white,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(defaultCornerRadius)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('New Booking',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20)),
                    const SizedBox(height: defaultPadding * 2),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedCustomerType == CustomerType.registered
                                  ? Colors.blue
                                  : (themeNotifier.isDarkMode ? Colors.white.withOpacity(0.2) 
                                                              : Colors.black.withOpacity(0.2)
                                    ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedCustomerType = CustomerType.registered;
                              });
                            },
                            child: Text(
                              'Registered Customer',
                              style: TextStyle(
                                color: selectedCustomerType == CustomerType.registered
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: defaultPadding),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedCustomerType == CustomerType.unregistered
                                  ? Colors.blue
                                  : Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedCustomerType = CustomerType.unregistered;
                              });
                            },
                            child: Text(
                              'Unregistered Customer',
                              style: TextStyle(
                                color: selectedCustomerType == CustomerType.unregistered
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    
                    _buildCustomerInfoSection(),
                    const SizedBox(height: defaultPadding * 2),

                    const Text('Room selection',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: defaultPadding),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding * 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: themeNotifier.isDarkMode
                            ? darkTertiaryBgColor
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(defaultCornerRadius),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.hotel,
                              color: themeNotifier.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          const SizedBox(width: defaultPadding),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Text(
                                  'Select Room',
                                  style: TextStyle(
                                    color: themeNotifier.isDarkMode
                                        ? Colors.white24
                                        : Colors.black38),
                                ),
                                isExpanded: true,
                                value: selectedRoom,
                                items: rooms.map((room) {
                                  bool isAvailable = isRoomAvailable(room['id']);
                                  return DropdownMenuItem<String>(
                                    value: room['name'],
                                    enabled: isAvailable,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(room['name']),
                                        Text(
                                          '\$${room['price']}',
                                          style: TextStyle(
                                            color: isAvailable ? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRoom = newValue;
                                    if (newValue != null) {
                                      var room = rooms.firstWhere((r) => r['name'] == newValue);
                                      totalAmount = double.tryParse(room['price'].toString()) ?? 0.0;
                                    } else {
                                      totalAmount = 0.0;
                                    }
                                  });
                                },
                                isDense: true,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    const Text('Date selection',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: defaultPadding),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding * 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: themeNotifier.isDarkMode
                                  ? darkTertiaryBgColor
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(defaultCornerRadius),
                            ),
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: themeNotifier.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  const SizedBox(width: defaultPadding),
                                  Text(
                                    checkInDate != null
                                        ? '${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'
                                        : 'Check-in Date',
                                    style: TextStyle(
                                      color: checkInDate != null
                                          ? (themeNotifier.isDarkMode
                                              ? Colors.white
                                              : Colors.black)
                                          : (themeNotifier.isDarkMode
                                              ? Colors.white24
                                              : Colors.black38),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: defaultPadding),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding * 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: themeNotifier.isDarkMode
                                  ? darkTertiaryBgColor
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(defaultCornerRadius),
                            ),
                            child: InkWell(
                              onTap: () => _selectDate(context, false),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: themeNotifier.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  const SizedBox(width: defaultPadding),
                                  Text(
                                    checkOutDate != null
                                        ? '${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'
                                        : 'Check-out Date',
                                    style: TextStyle(
                                      color: checkOutDate != null
                                          ? (themeNotifier.isDarkMode
                                              ? Colors.white
                                              : Colors.black)
                                          : (themeNotifier.isDarkMode
                                              ? Colors.white24
                                              : Colors.black38),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: defaultPadding * 2)),
            Expanded(
              flex: 1,
              child: Container(
                height: 400.0,
                padding: const EdgeInsets.all(defaultPadding * 2),
                decoration: BoxDecoration(
                  color: themeNotifier.isDarkMode
                      ? darkSecondaryBgColor
                      : Colors.white,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(defaultCornerRadius)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    BookingSummaryItem(
                      title: 'Room',
                      value: selectedRoom ?? 'Not selected',
                      icon: Icons.hotel,
                    ),
                    const SizedBox(height: defaultPadding),
                    BookingSummaryItem(
                      title: 'Check-in',
                      value: checkInDate != null
                          ? '${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'
                          : 'Not selected',
                      icon: Icons.login,
                    ),
                    const SizedBox(height: defaultPadding),
                    BookingSummaryItem(
                      title: 'Check-out',
                      value: checkOutDate != null
                          ? '${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'
                          : 'Not selected',
                      icon: Icons.logout,
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    Divider(color: Colors.grey.withOpacity(0.2)),
                    const SizedBox(height: defaultPadding),
                    const Text(
                      'Total Amount',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      (checkInDate == null || checkOutDate == null)
                          ? '\$${totalAmount.toStringAsFixed(2)}'
                          : '\$${(totalAmount * checkOutDate!.difference(checkInDate!).inDays).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                defaultCornerRadius - defaultPadding),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Booking Confirmation'),
                                content: const Text('Are you sure you want to confirm this booking?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      confirmBooking();
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
                        },
                        child: const Text(
                          'Confirm Booking',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingInputField extends StatelessWidget {
  const BookingInputField({
    super.key,
    required this.hintText,
    required this.icon,
    this.typeOfKeyboard,
    this.onChanged,
    this.controller,
    this.obscureText = false,
  });

  final String hintText;
  final Icon icon;
  final TextInputType? typeOfKeyboard;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            color: themeNotifier.isDarkMode ? Colors.white24 : Colors.black38),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(defaultCornerRadius)),
        fillColor:
            themeNotifier.isDarkMode ? darkTertiaryBgColor : Colors.white,
        filled: true,
        prefixIcon: icon,
        prefixIconColor: themeNotifier.isDarkMode ? Colors.white : Colors.black,
      ),
      keyboardType: typeOfKeyboard,
      onChanged: onChanged,
    );
  }
}

class BookingSummaryItem extends StatelessWidget {
  const BookingSummaryItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(width: defaultPadding),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontSize: 12,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
