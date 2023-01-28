import 'package:diary/resources/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DeletedScreen extends StatefulWidget {
  const DeletedScreen({super.key});

  @override
  State<DeletedScreen> createState() => _DeletedScreenState();
}

class _DeletedScreenState extends State<DeletedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [const CustomAppBar(title: 'Deleted')],
      )),
    );
  }
}
