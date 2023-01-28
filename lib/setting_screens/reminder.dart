import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';

import '../resources/custom_app_bar.dart';
import '../resources/my_app_theme.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isReminder = false;
  String selectedReminder = 'Daily Reminder';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [const CustomAppBar(title: 'Reminder'), reminderContainer()],
    )));
  }

  Container reminderContainer() {
    List<String> reminderList = ['Daily reminder', 'Weekly reminder'];
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Ionicons.alarm,
                    color: MyAppTheme.primaryTxtColor,
                  ),
                  const SizedBox(width: 15),
                  DropdownButtonHideUnderline(
                      child: DropdownButton(
                    icon: Icon(
                      Icons.arrow_drop_down_rounded,
                      color: MyAppTheme.primaryTxtColor,
                    ),
                    alignment: Alignment.centerLeft,
                    hint: Text(
                      selectedReminder,
                      style: TextStyle(
                          color: MyAppTheme.primaryTxtColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    items: reminderList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (Object? value) {
                      setState(() {
                        selectedReminder = value as String;
                      });
                    },
                  ))
                ],
              ),
              Switch(
                  activeColor: MyAppTheme.primaryColor,
                  activeTrackColor: MyAppTheme.primaryColor.withOpacity(0.5),
                  inactiveThumbColor: MyAppTheme.searchColor,
                  inactiveTrackColor: MyAppTheme.searchColor.withOpacity(0.5),
                  value: isReminder,
                  onChanged: ((value) {
                    setState(() {
                      isReminder = !isReminder;
                    });
                  }))
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: MyAppTheme.primaryTxtColor,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Alarm time',
                    style: TextStyle(
                        color: MyAppTheme.primaryTxtColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              InkWell(
                onTap: (() {
                  Fluttertoast.showToast(msg: 'change  color ');
                }),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '8:30 PM',
                        style: TextStyle(
                          color: MyAppTheme.searchColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: MyAppTheme.primaryTxtColor,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
