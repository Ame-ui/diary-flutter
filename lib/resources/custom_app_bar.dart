import 'package:flutter/material.dart';

import 'my_app_theme.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
      decoration: BoxDecoration(
          color: MyAppTheme.itemBgColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: MyAppTheme.inactiveDotColor,
              blurRadius: 4,
              blurStyle: BlurStyle.normal,
              offset: const Offset(4, 4),
              //spreadRadius: 5
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            icon: const Icon(Icons.keyboard_arrow_left),
            color: MyAppTheme.primaryTxtColor,
            iconSize: 30,
          ),
          const SizedBox(width: 5),
          SizedBox(
            //width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              title,
              style: TextStyle(
                  color: MyAppTheme.primaryTxtColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu',
                  fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }
}
