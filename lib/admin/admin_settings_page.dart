import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'admin_theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(defaultPadding * 2),
          padding: const EdgeInsets.all(defaultPadding * 2),
          decoration: BoxDecoration(
            color:
                themeNotifier.isDarkMode ? darkSecondaryBgColor : Colors.white,
            borderRadius:
                const BorderRadius.all(Radius.circular(defaultCornerRadius)),
          ),
          child: Column(
            children: [
              DarkModeSwitch(themeNotifier: themeNotifier),
              const SizedBox(height: defaultPadding),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        color: themeNotifier.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                    CupertinoSwitch(
                      value: true,
                      activeColor: Colors.blueAccent,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({
    super.key,
    required this.themeNotifier,
  });

  final ThemeNotifier themeNotifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dark Mode',
          style: TextStyle(
            color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        CupertinoSwitch(
          value: themeNotifier.isDarkMode,
          activeColor: Colors.blueAccent,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
        ),
      ],
    );
  }
}
