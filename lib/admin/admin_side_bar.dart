import 'package:flutter/material.dart';
import 'constants.dart';
import 'admin_home_page.dart';
import 'admin_rooms_page.dart';
import 'admin_bookings_page.dart';
import 'admin_history_page.dart';
import 'admin_settings_page.dart';
import 'package:provider/provider.dart';
import 'admin_theme_notifier.dart';

typedef PageCallback = void Function(Widget page, String title);

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
    required this.onPageChange,
    required this.currentPage,
  });

  final PageCallback onPageChange;
  final String currentPage;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Drawer(
      width: 160,
      backgroundColor:
          themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: defaultPadding * 3, bottom: defaultPadding),
              child: Text(
                'Hotel IT3180',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w600,
                  color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            DrawerListTile(
              icon: const Icon(Icons.home),
              title: 'Home',
              isSelected: currentPage == 'Home',
              press: () => onPageChange(const HomePage(), 'Home'),
            ),
            DrawerListTile(
              icon: const Icon(Icons.grid_view_rounded),
              title: 'Rooms',
              isSelected: currentPage == 'Rooms',
              press: () => onPageChange(const RoomsPage(), 'Rooms'),
            ),
            DrawerListTile(
              icon: const Icon(Icons.edit_note_outlined),
              title: 'Bookings',
              isSelected: currentPage == 'Bookings',
              press: () => onPageChange(const BookingsPage(), 'Bookings'),
            ),
            DrawerListTile(
              icon: const Icon(Icons.history),
              title: 'History',
              isSelected: currentPage == 'History',
              press: () => onPageChange(const HistoryPage(), 'History'),
            ),
            DrawerListTile(
              icon: const Icon(Icons.settings),
              title: 'Settings',
              isSelected: currentPage == 'Settings',
              press: () => onPageChange(const SettingsPage(), 'Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
    required this.isSelected,
  });

  final String title;
  final Icon icon;
  final VoidCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: ListTile(
        minTileHeight: 8.0,
        minLeadingWidth: 0.0,
        onTap: press,
        splashColor: Colors.transparent,
        horizontalTitleGap: defaultPadding * 1.25,
        leading: IconTheme(
          data: IconThemeData(
              color: getElementColor(isSelected, themeNotifier.isDarkMode)),
          child: icon,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultCornerRadius)),
        tileColor: isSelected
            ? (themeNotifier.isDarkMode
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.2))
            : Colors.transparent,
        hoverColor: themeNotifier.isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.1),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w600,
            color: getElementColor(isSelected, themeNotifier.isDarkMode),
          ),
        ),
      ),
    );
  }
}
