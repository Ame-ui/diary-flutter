import 'dart:io';

import 'package:diary/model/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserModelProvider extends ChangeNotifier {
  UserModel userModel = UserModel(
      imgFile: File(''),
      name: '',
      birthday: DateTime.now(),
      gender: '',
      securityQuestion: '',
      securityAnswer: '',
      tempPswd: '',
      password: '');

  void changeImg(File newF) {
    userModel.imgFile = newF;
    notifyListeners();
  }

  void changeName(String newN) {
    userModel.name = newN;
    notifyListeners();
  }

  void changeBrithday(DateTime newD) {
    userModel.birthday = newD;
    notifyListeners();
  }

  void changeGender(String newG) {
    userModel.gender = newG;
    notifyListeners();
  }

  void changeSecurityQuestion(String newQ) {
    userModel.securityQuestion = newQ;
    notifyListeners();
  }

  void changeSecurityAnswer(String newAns) {
    userModel.securityAnswer = newAns;
    notifyListeners();
  }

  void changeTempPassword(String temp) {
    userModel.tempPswd = temp;
    notifyListeners();
  }

  void changePassword(String newPswd) {
    userModel.password = newPswd;
    notifyListeners();
  }

  void addToPassword(String char, bool check) {
    if (check) {
      userModel.password += char;
    } else {
      userModel.tempPswd += char;
    }
    notifyListeners();
  }

  void backSpacePassword(bool check) {
    if (check) {
      userModel.password = userModel.password.substring(0, userModel.password.length - 1);
    } else {
      userModel.tempPswd = userModel.tempPswd.substring(0, userModel.tempPswd.length - 1);
    }
    notifyListeners();
  }

  bool checkSecurityData() {
    if (userModel.securityAnswer != '' ||
        userModel.securityQuestion != '' ||
        userModel.password != '') {
      return true;
    }
    return false;
  }
}
