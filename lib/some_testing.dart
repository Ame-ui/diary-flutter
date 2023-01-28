import 'package:diary/resources/my_app_theme.dart';
import 'package:flutter/material.dart';

class SomeTesting extends StatefulWidget {
  const SomeTesting({super.key});

  @override
  State<SomeTesting> createState() => _SomeTestingState();
}

class _SomeTestingState extends State<SomeTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExpansionTile(
              title: Text(
                'Setting',
                style: TextStyle(color: MyAppTheme.primaryTxtColor),
              ),
              leading: Icon(
                Icons.settings,
                color: MyAppTheme.primaryTxtColor,
              ),
              children: const [
                Text('item 1'),
                Text('item 2'),
                Text('item 3'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
