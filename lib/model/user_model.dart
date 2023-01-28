import 'dart:io' as io;

class UserModel {
  io.File imgFile;
  String name;
  DateTime birthday;
  String gender;
  String securityQuestion;
  String securityAnswer;
  String tempPswd;
  String password;
  UserModel(
      {required this.imgFile,
      required this.name,
      required this.birthday,
      required this.gender,
      required this.securityQuestion,
      required this.securityAnswer,
      required this.tempPswd,
      required this.password});
}
