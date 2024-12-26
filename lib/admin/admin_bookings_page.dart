import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_theme_notifier.dart';

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

  final Map<String, double> roomPrices = {
    'DeluxeDouble - 101': 100.0,
    'ExecutiveDouble - 102': 150.0,
    'Junior Suite Double - 201': 200.0,
  };

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

          // Kiểm tra checkOutDate nếu đã chọn trước đó
          if (checkOutDate != null &&
              checkOutDate!.isBefore(picked.add(const Duration(days: 1)))) {
            checkOutDate = null; // Reset checkOutDate nếu không hợp lệ
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Check-out date must be at least 1 day after check-in date!'),
                backgroundColor: Colors.black,
              ),
            );
          }
        } else {
          // Kiểm tra nếu checkOutDate nhỏ hơn hoặc bằng checkInDate
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

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
            top: defaultPadding * 2,
            left: defaultPadding * 2,
            right: defaultPadding * 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 1000.0,
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
                    const Text('Customer information',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: defaultPadding),
                    const BookingInputField(
                      hintText: 'Full Name',
                      icon: Icon(Icons.person),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    const BookingInputField(
                      hintText: 'Phone Number',
                      icon: Icon(Icons.phone),
                      typeOfKeyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    const BookingInputField(
                      hintText: 'Email',
                      icon: Icon(Icons.email_rounded),
                      typeOfKeyboard: TextInputType.emailAddress,
                    ),
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
                                items: roomPrices.keys.map((String room) {
                                  return DropdownMenuItem<String>(
                                    value: room,
                                    child: Text(room),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRoom = newValue;
                                    totalAmount = roomPrices[newValue] ?? 0.0;
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
                          // Add booking confirmation logic here
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
  });

  final String hintText;
  final Icon icon;
  final TextInputType? typeOfKeyboard;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return TextField(
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
