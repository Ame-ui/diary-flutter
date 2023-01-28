import 'dart:io' as io;

import 'package:diary/resources/diary_content_widgets.dart';
import 'package:diary/resources/my_app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DiaryContentProvider extends ChangeNotifier {
  //var _textEditingControllerList = <int, TextEditingController>{};

  List<DiaryContentWidget> contentList = [];

  DiaryContentProvider() {
    _addTextField();
  }

  void _addTextField() {
    contentList.add(DiaryContentWidget(
      widgetType: 'text',
      index: contentList.length,
    ));
    //notifyListeners();
  }

  void addImage(io.File file) {
    contentList.add(DiaryContentWidget(
      widgetType: 'image',
      index: contentList.length,
      file: file,
    ));
    _addTextField();
    notifyListeners();
  }

  void addVideo(io.File file) {
    contentList.add(DiaryContentWidget(
      widgetType: 'video',
      index: contentList.length,
      file: file,
    ));
    _addTextField();
    notifyListeners();
  }

  void removeWidget(int index) {
    if (contentList[index + 1].textController.text.isNotEmpty) {
      if (contentList[index - 1].textController.text.isEmpty) {
        contentList[index - 1].textController.text = contentList[index + 1].textController.text;
      } else {
        contentList[index - 1].textController.text +=
            '\n${contentList[index + 1].textController.text}';
      }
    }
    contentList.removeAt(index);
    contentList.removeAt(index);
    _adjustListIndex(index);
    notifyListeners();
  }

  void _adjustListIndex(int index) {
    contentList.forEach((element) {
      if (element.index >= index + 2) {
        element.index -= 2;
      }
    });
  }
}
