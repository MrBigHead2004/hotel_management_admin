import 'package:flutter_2/admin/admin_login_page.dart';

import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_theme_notifier.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.pageTitle,
  });

  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: defaultPadding * 2),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: defaultPadding * 3),
              child: Text(pageTitle,
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w600,
                    color:
                        themeNotifier.isDarkMode ? Colors.white : Colors.black,
                  )),
            ),
            const Spacer(flex: 2),
            const Expanded(child: SearchField()),
            const ProfileCard(),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return TextField(
      decoration: InputDecoration(
          fillColor:
              themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.only(left: defaultPadding * 2),
          hintText: 'Search...',
          hintStyle: TextStyle(
              color:
                  themeNotifier.isDarkMode ? Colors.white24 : Colors.black38),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(defaultCornerRadius),
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(defaultCornerRadius * 0.75),
            ),
            child: const Icon(Icons.search, color: Colors.white),
          )),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      margin: const EdgeInsets.only(
          left: defaultPadding, right: defaultPadding * 2),
      decoration: BoxDecoration(
        color: themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
        borderRadius: BorderRadius.circular(defaultCornerRadius),
        border: Border.all(
            color: themeNotifier.isDarkMode ? Colors.white10 : Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 0.5, vertical: defaultPadding / 2),
      child: PopupMenuButton<String>(
        offset: const Offset(-40, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultCornerRadius),
        ),
        color: themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.person_outline,
                    color:
                        themeNotifier.isDarkMode ? Colors.white : Colors.black),
                const SizedBox(width: defaultPadding),
                Text('Profile',
                    style: TextStyle(
                        color: themeNotifier.isDarkMode
                            ? Colors.white
                            : Colors.black)),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings_outlined,
                    color:
                        themeNotifier.isDarkMode ? Colors.white : Colors.black),
                const SizedBox(width: defaultPadding),
                Text('Settings',
                    style: TextStyle(
                        color: themeNotifier.isDarkMode
                            ? Colors.white
                            : Colors.black)),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout_outlined, color: Colors.redAccent),
                SizedBox(width: defaultPadding),
                Text('Log Out',
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
        onSelected: (String value) {
          switch (value) {
            case 'profile':
              // handle profile action
              break;
            case 'settings':
              // handle settings action
              break;
            case 'logout':
              // handle logout action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
              break;
          }
        },
        popUpAnimationStyle: AnimationStyle(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutExpo),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: defaultPadding),
                child: Icon(Icons.person,
                    color:
                        themeNotifier.isDarkMode ? Colors.white : Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 4),
                child: Text('Admin',
                    style: TextStyle(
                        fontSize: 16,
                        color: themeNotifier.isDarkMode
                            ? Colors.white
                            : Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: defaultPadding),
                child: Icon(Icons.keyboard_arrow_down,
                    color:
                        themeNotifier.isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
