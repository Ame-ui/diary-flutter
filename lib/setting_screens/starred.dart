import 'package:flutter/material.dart';

import '../resources/custom_app_bar.dart';

class StarredScreen extends StatefulWidget {
  const StarredScreen({super.key});

  @override
  State<StarredScreen> createState() => _StarredScreenState();
}

class _StarredScreenState extends State<StarredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [const CustomAppBar(title: 'Starred')],
      )),
    );
  }
}
