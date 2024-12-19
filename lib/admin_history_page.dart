import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_theme_notifier.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
        Expanded(
          child: ListView(
            children: const <Widget>[
              BookingTile(
                title: 'Booking 1',
                checkInDate: '05-12-2024',
                checkOutDate: '10-12-2024',
                status: 'Confirmed',
              ),
              BookingTile(
                title: 'Booking 2',
                checkInDate: '05-12-2024',
                checkOutDate: '10-12-2024',
                status: 'Pending',
              ),
              BookingTile(
                title: 'Booking 3',
                checkInDate: '05-12-2024',
                checkOutDate: '10-12-2024',
                status: 'Cancelled',
              ),
            ],
          )
        ),
      ],
    );
  }
}

class BookingTile extends StatelessWidget {
  const BookingTile({
    super.key,
    required this.title,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
  });

  final String title;
  final String checkInDate;
  final String checkOutDate;
  final String status;
  // final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding * 2, vertical: defaultPadding / 2),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
        borderRadius: BorderRadius.circular(defaultCornerRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: defaultPadding / 2)),
            Text('Check-in: $checkInDate'),
            Text('Check-out: $checkOutDate'),
            const Padding(padding: EdgeInsets.only(top: defaultPadding / 2)),
            Text(
              status, 
              style: TextStyle(
                color: status == 'Confirmed' ? Colors.green : status == 'Pending' ? Colors.orange : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultCornerRadius)),
        onTap: () => debugPrint('$title tapped'),
        splashColor: Colors.transparent,
      ),
    );
  }
} 