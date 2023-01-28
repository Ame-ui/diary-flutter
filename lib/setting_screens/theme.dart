import 'package:diary/resources/custom_app_bar.dart';
import 'package:diary/resources/my_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  bool isDarkmode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [const CustomAppBar(title: 'Theme'), themeContainer()],
    )));
  }

  Container themeContainer() {
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
                    Icons.dark_mode_rounded,
                    color: MyAppTheme.primaryTxtColor,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Dark mode',
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
                  value: isDarkmode,
                  onChanged: ((value) {
                    setState(() {
                      isDarkmode = !isDarkmode;
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
                    Icons.color_lens_rounded,
                    color: MyAppTheme.primaryTxtColor,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Change main color',
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
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: MyAppTheme.primaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10)))),
              )
            ],
          ),
        ],
      ),
    );
  }
}
