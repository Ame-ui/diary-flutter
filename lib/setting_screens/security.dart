import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';

import '../resources/custom_app_bar.dart';
import '../resources/my_app_theme.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool isPasswordLock = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [const CustomAppBar(title: 'Security'), securityContainer()],
    )));
  }

  Container securityContainer() {
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
                    Ionicons.lock_closed,
                    color: MyAppTheme.primaryTxtColor,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Password Lock',
                    style: TextStyle(
                        color: MyAppTheme.primaryTxtColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Switch(
                  activeColor: MyAppTheme.primaryColor,
                  activeTrackColor: MyAppTheme.primaryColor.withOpacity(0.5),
                  inactiveThumbColor: MyAppTheme.searchColor,
                  inactiveTrackColor: MyAppTheme.searchColor.withOpacity(0.5),
                  value: isPasswordLock,
                  onChanged: ((value) {
                    setState(() {
                      isPasswordLock = !isPasswordLock;
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
                    Icons.lock_rounded,
                    color: MyAppTheme.primaryTxtColor,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Change Password',
                    style: TextStyle(
                        color: MyAppTheme.primaryTxtColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              IconButton(
                onPressed: (() {
                  Fluttertoast.showToast(msg: 'change pswd');
                }),
                icon: const Icon(Icons.keyboard_arrow_right),
                color: MyAppTheme.primaryTxtColor,
                iconSize: 30,
              )
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
                    Icons.key,
                    color: MyAppTheme.primaryTxtColor,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Set up security question',
                    style: TextStyle(
                        color: MyAppTheme.primaryTxtColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              IconButton(
                onPressed: (() {
                  Fluttertoast.showToast(msg: 'set up ');
                }),
                icon: const Icon(Icons.keyboard_arrow_right),
                color: MyAppTheme.primaryTxtColor,
                iconSize: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
