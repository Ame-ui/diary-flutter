import 'package:diary/provider/user_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../resources/my_app_theme.dart';
import '../route/route_names.dart';

class SecurityQuestionScreen extends StatefulWidget {
  const SecurityQuestionScreen({super.key});
  //final String password;

  @override
  State<SecurityQuestionScreen> createState() => _SecurityQuestionScreenState();
}

class _SecurityQuestionScreenState extends State<SecurityQuestionScreen> {
  TextEditingController _ansController = TextEditingController();
  List<String> questionList = [
    'What is your favorite color?',
    'What is your favorite movie?',
    'What is your favorite food?'
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    _ansController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Fluttertoast.showToast(msg: widget.password);
    var userModelProvider = Provider.of<UserModelProvider>(context, listen: false);
    Fluttertoast.showToast(msg: userModelProvider.userModel.password);
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/app_bg.png'), fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.only(top: 45, bottom: 15, left: 15, right: 15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: (() => Navigator.of(context).pop()),
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                      ),
                      color: MyAppTheme.primaryTxtColor,
                      iconSize: 30,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set up security question',
                          style: TextStyle(
                            color: MyAppTheme.primaryTxtColor,
                            fontFamily: 'Ubuntu',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'You can set up a security question in case you \'forgot password.',
                          style: TextStyle(
                            color: MyAppTheme.primaryTxtColor,
                            fontFamily: 'Ubuntu',
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: DropdownButtonFormField(
                          //value: selectedSecurityQnA.question,
                          icon: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: MyAppTheme.primaryTxtColor,
                          ),
                          iconSize: 30,
                          decoration: const InputDecoration(border: InputBorder.none),
                          hint: Text(
                            'Select your Question',
                            style: TextStyle(color: MyAppTheme.disableColor),
                          ),
                          items: questionList
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: ((value) {
                            userModelProvider.changeSecurityQuestion(value as String);
                            _ansController.text = '';
                            //Fluttertoast.showToast(msg: selectedSecurityQnA.question);
                          })),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      width: 350,
                      decoration: BoxDecoration(
                          color: MyAppTheme.txtFieldColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        controller: _ansController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Please answer the question',
                            hintStyle: TextStyle(color: MyAppTheme.disableColor)),
                        onTap: () {
                          if (userModelProvider.userModel.securityQuestion.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Please choose a question!',
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                            backgroundColor: MyAppTheme.primaryColor),
                        onPressed: (() {
                          if (_ansController.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Answer can\'t be empty!',
                              backgroundColor: Colors.red,
                            );
                          } else if (userModelProvider.userModel.securityQuestion.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Please choose a question!',
                              backgroundColor: Colors.red,
                            );
                          } else {
                            userModelProvider.changeSecurityAnswer(_ansController.text.toString());
                            Navigator.of(context).pushReplacementNamed(RouteNames.onboardingScreen);
                            Fluttertoast.showToast(
                                msg: 'Setting password completed', backgroundColor: Colors.green);
                          }
                          // Navigator.of(context)
                          //     .pushNamed(RouteNames.setPasswordScreen);
                        }),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 18,
                          ),
                        )),
                  ),
                ]),
          )),
    );
  }
}
