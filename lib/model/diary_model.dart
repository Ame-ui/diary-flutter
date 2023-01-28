import 'dart:io' as io;

import 'package:flutter/cupertino.dart';

class DiaryModel {
  String title;
  String subTitle;
  String mood;
  DateTime date;
  List<io.File> imgFile;

  DiaryModel(
      {required this.title,
      required this.subTitle,
      required this.mood,
      required this.date,
      required this.imgFile});
}
