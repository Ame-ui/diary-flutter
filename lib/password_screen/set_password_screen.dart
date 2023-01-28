import 'package:diary/provider/user_model_provider.dart';
import 'package:diary/route/route_names.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../resources/my_app_theme.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  //ValueNotifier<String> passwordText = ValueNotifier('');

  // void addToPassword(int index) {
  //   passwordText.value += (index + 1).toString();
  //   //Fluttertoast.showToast(msg: passwordText.value);
  // }

  @override
  Widget build(BuildContext context) {
    var userModelProvider = Provider.of<UserModelProvider>(context, listen: false);
    //Fluttertoast.showToast(msg: 'set pswd build');
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/app_bg.png'), fit: BoxFit.cover)),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text(
                      'Set Password',
                      style: TextStyle(
                        color: MyAppTheme.primaryTxtColor,
                        fontFamily: 'Ubuntu',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<UserModelProvider>(
                      builder: ((context, provider, child) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color: provider.userModel.tempPswd.isEmpty
                                    ? MyAppTheme.inactiveDotColor
                                    : MyAppTheme.primaryColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.circle,
                                color: provider.userModel.tempPswd.length >= 2
                                    ? MyAppTheme.primaryColor
                                    : MyAppTheme.inactiveDotColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.circle,
                                color: provider.userModel.tempPswd.length >= 3
                                    ? MyAppTheme.primaryColor
                                    : MyAppTheme.inactiveDotColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.circle,
                                color: provider.userModel.tempPswd.length == 4
                                    ? MyAppTheme.primaryColor
                                    : MyAppTheme.inactiveDotColor,
                                size: 18,
                              ),
                            ],
                          )),
                    ),
                    Text(
                      'Please enter password',
                      style: TextStyle(
                        color: MyAppTheme.primaryTxtColor,
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: MyAppTheme.primaryColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50), topRight: Radius.circular(50))),
                child: GridView.builder(
                    itemCount: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: ((context, index) {
                      return (index == 9)
                          ? IconButton(
                              onPressed: (() {
                                if (userModelProvider.userModel.tempPswd.isEmpty) {
                                  Fluttertoast.showToast(msg: 'There is nothing to delete');
                                } else {
                                  userModelProvider.backSpacePassword(false);
                                  //Fluttertoast.showToast(msg: passwordText.value);
                                }
                              }),
                              icon: const Icon(
                                Icons.backspace,
                                color: Colors.white,
                              ))
                          : (index == 10)
                              ? TextButton(
                                  onPressed: (() {
                                    if (userModelProvider.userModel.tempPswd.length < 4) {
                                      userModelProvider.addToPassword('0', false);
                                      //Fluttertoast.showToast(msg: passwordText.value);
                                    }
                                  }),
                                  child: const Text(
                                    '0',
                                    style: TextStyle(
                                        color: Colors.white, fontFamily: 'Ubuntu', fontSize: 30),
                                  ))
                              : (index == 11)
                                  ? IconButton(
                                      onPressed: (() {
                                        if (userModelProvider.userModel.tempPswd.length == 4) {
                                          Navigator.pushNamed(
                                              context, RouteNames.confirmPasswordScreen);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Password must be 4 numbers!');
                                        }
                                      }),
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 30,
                                      ))
                                  : TextButton(
                                      onPressed: (() {
                                        if (userModelProvider.userModel.tempPswd.length < 4) {
                                          userModelProvider.addToPassword(
                                              (index + 1).toString(), false);
                                          //Fluttertoast.showToast(msg: passwordText.value);
                                        }
                                      }),
                                      child: Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Ubuntu',
                                            fontSize: 30),
                                      ));
                    })),
              ),
            )
          ],
        ),
      ),
    );
  }
}
