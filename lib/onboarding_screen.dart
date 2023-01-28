import 'dart:io' as io;

import 'package:diary/provider/user_model_provider.dart';
import 'package:diary/resources/my_app_theme.dart';
import 'package:diary/route/route_names.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  //ValueNotifier<DateTime> birthday = ValueNotifier(DateTime.now());
  //ValueNotifier<String> selectedGender = ValueNotifier('');

  final DateFormat dateFormater = DateFormat('d/M/y');

  final TextEditingController _nameTxtController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  final PageController _pageController = PageController();
  PageController _pageControllerDay = PageController(viewportFraction: 0.4);
  PageController _pageControllerMonth = PageController(viewportFraction: 0.4);
  PageController _pageControllerYear = PageController(viewportFraction: 0.4);

  ValueNotifier<int> selectedDayIndex = ValueNotifier<int>(0);
  ValueNotifier<int> selectedMonthIndex = ValueNotifier<int>(0);
  ValueNotifier<int> selectedYearIndex = ValueNotifier<int>(0);

  int previousMonthIndex = 0;

  ValueNotifier<int> curentPage = ValueNotifier<int>(0);
  io.File imageFile = io.File('');
  List<String> genderlist = ['Male', 'Female'];
  ValueNotifier<bool> imageAlreadySelected = ValueNotifier(false);

  List<int> dayList = [];
  List<int> monthList = [];
  List<int> yearList = [];

  @override
  void dispose() {
    selectedDayIndex.dispose();
    selectedMonthIndex.dispose();
    selectedYearIndex.dispose();
    _pageControllerDay.dispose();
    _pageControllerMonth.dispose();
    _pageControllerYear.dispose();
    _pageController.dispose();
    _nameTxtController.dispose();
    curentPage.dispose();
    imageAlreadySelected.dispose();
    super.dispose();
  }

  List<int> addingDMY(int start, int end) {
    List<int> tempList = [];
    while (start <= end) {
      tempList.add(start);
      start += 1;
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    Fluttertoast.showToast(msg: 'build');
    var userModelProvider = Provider.of<UserModelProvider>(context, listen: false);
    if (userModelProvider.checkSecurityData() && curentPage.value != 2) {
      Timer(const Duration(milliseconds: 100), (() {
        _pageController.jumpToPage(1);
      }));
    }

    //initializing day, month, year
    dayList = addingDMY(1, 31);
    monthList = addingDMY(1, 12);
    yearList = addingDMY(1922, DateTime.now().year);
    previousMonthIndex = monthList.indexOf(userModelProvider.userModel.birthday.month);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/app_bg.png'), fit: BoxFit.cover),
          ),
          child: ValueListenableBuilder(
              valueListenable: curentPage,
              builder: ((context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: ((value) {
                          curentPage.value = value;
                        }),
                        children: [
                          Column(
                            children: [
                              Flexible(
                                flex: 6,
                                fit: FlexFit.tight,
                                child: showPageInfo(
                                  'Memory',
                                  'assets/memory.png',
                                  'Write your days and\ncheck your memories.',
                                ),
                              ),
                              const Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: SizedBox(
                                    height: 25,
                                  ))
                            ],
                          ),
                          Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 6,
                                fit: FlexFit.tight,
                                child: showPageInfo(
                                  'Privacy',
                                  'assets/privacy.png',
                                  'We recommend setting a\npassword to keep your diaries private',
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(16),
                                          backgroundColor: MyAppTheme.primaryColor),
                                      onPressed: (() {
                                        Navigator.of(context)
                                            .pushNamed(RouteNames.setPasswordScreen);
                                      }),
                                      child: const Text(
                                        'Set Password',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 18,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                              scrollDirection: Axis.vertical, child: profilePage()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: bottomRow(),
                    ),
                  ],
                );
              }))),
    );
  }

  Row bottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: curentPage.value != 2,
          replacement: const SizedBox(
            width: 8,
          ),
          child: TextButton(
            onPressed: () {
              _pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 200), curve: Curves.linear);
            },
            child: Row(
              children: [
                Text(
                  'Skip',
                  style: TextStyle(
                    color: MyAppTheme.disableColor,
                    fontFamily: 'Ubuntu',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                splashRadius: 0.1,
                onPressed: () {
                  _pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 200), curve: Curves.linear);
                },
                icon: Icon(
                  Icons.circle,
                  color:
                      curentPage.value == 0 ? MyAppTheme.primaryColor : MyAppTheme.inactiveDotColor,
                  size: 18,
                )),
            IconButton(
                splashRadius: 0.1,
                onPressed: () {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 200), curve: Curves.linear);
                },
                icon: Icon(
                  Icons.circle,
                  color:
                      curentPage.value == 1 ? MyAppTheme.primaryColor : MyAppTheme.inactiveDotColor,
                  size: 18,
                )),
            IconButton(
                splashRadius: 0.1,
                onPressed: () {
                  _pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 200), curve: Curves.linear);
                },
                icon: Icon(
                  Icons.circle,
                  color:
                      curentPage.value == 2 ? MyAppTheme.primaryColor : MyAppTheme.inactiveDotColor,
                  size: 18,
                )),
          ],
        ),
        Visibility(
          visible: curentPage.value != 2,
          child: InkWell(
            onTap: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 200), curve: Curves.linear),
            child: Row(
              children: [
                Text(
                  'Next',
                  style: TextStyle(
                    color: MyAppTheme.disableColor,
                    fontFamily: 'Ubuntu',
                    fontSize: 16,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: MyAppTheme.disableColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding showPageInfo(String title, String assetName, String subTitle) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 1,
          ),
          Text(
            title,
            style: TextStyle(
              color: MyAppTheme.primaryTxtColor,
              fontFamily: 'Ubuntu',
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image(image: AssetImage(assetName)),
          Text(
            subTitle,
            style: TextStyle(
              color: MyAppTheme.primaryTxtColor,
              fontFamily: 'Ubuntu',
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Padding profilePage() {
    var userModelProvider = Provider.of<UserModelProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 70),
      child: Column(
        children: [
          Text(
            'Hey,\nLets Make Your Profile',
            style: TextStyle(
              color: MyAppTheme.primaryTxtColor,
              fontFamily: 'Ubuntu',
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: InkWell(
              onTap: (() {
                _getUserImage();
              }),
              child: Stack(
                alignment: const Alignment(0.8, 0.8),
                children: [
                  ValueListenableBuilder(
                    valueListenable: imageAlreadySelected,
                    builder: (BuildContext context, dynamic value, Widget? child) {
                      return imageAlreadySelected.value
                          ? CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 100,
                              backgroundImage: FileImage(imageFile),
                            )
                          : const Image(
                              width: 200,
                              height: 200,
                              image: AssetImage('assets/profile_icon.png'),
                              fit: BoxFit.cover,
                            );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: MyAppTheme.inactiveDotColor),
                    child: Icon(
                      Icons.camera_alt,
                      color: MyAppTheme.txtFieldHintColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name',
                      style: TextStyle(
                          color: MyAppTheme.primaryTxtColor, fontFamily: 'Ubuntu', fontSize: 16)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        color: MyAppTheme.txtFieldColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: TextFormField(
                      controller: _nameTxtController,
                      decoration: InputDecoration(
                          hintText: 'Enter your name',
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: MyAppTheme.txtFieldHintColor, fontFamily: 'Ubuntu')),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name can\'t be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text('Date of Birth',
                      style: TextStyle(
                          color: MyAppTheme.primaryTxtColor, fontFamily: 'Ubuntu', fontSize: 16)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: MyAppTheme.txtFieldColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: InkWell(
                      onTap: (() {
                        adjustDateAlerdialogToDob();
                        showDialog(context: context, builder: ((context) => dateAlertDialog()));
                      }),
                      child: Consumer<UserModelProvider>(builder: ((context, provider, child) {
                        //Fluttertoast.showToast(msg: 'msg');
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateFormater.format(provider.userModel.birthday),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyAppTheme.txtFieldHintColor,
                                  fontFamily: 'Ubuntu'),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: MyAppTheme.txtFieldHintColor,
                            )
                          ],
                        );
                      })),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text('Gender',
                      style: TextStyle(
                          color: MyAppTheme.primaryTxtColor, fontFamily: 'Ubuntu', fontSize: 16)),
                  const SizedBox(height: 5),
                  Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: MyAppTheme.txtFieldColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: DropdownButtonFormField(
                        hint: const Text('Select your Gender'),
                        decoration: const InputDecoration(border: InputBorder.none),
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 16,
                            color: MyAppTheme.txtFieldHintColor),
                        items: genderlist
                            .map((e) => (DropdownMenuItem(value: e, child: Text(e))))
                            .toList(),
                        onChanged: ((value) {
                          Provider.of<UserModelProvider>(context, listen: false)
                              .changeGender(value as String);
                        }),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: MyAppTheme.txtFieldHintColor,
                        ),
                      )),
                  const SizedBox(height: 50),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: MyAppTheme.primaryColor),
                        onPressed: (() {
                          // if (imageFile == null ||
                          //     _nameTxtController.text.isEmpty ||
                          //     userModelProvider.userModel.birthday
                          //         .isAtSameMomentAs(DateTime.now()) ||
                          //     userModelProvider.userModel.gender.isEmpty) {
                          //   Fluttertoast.showToast(
                          //       msg: 'None of those field can\'t be empty!!!',
                          //       backgroundColor: Colors.red,
                          //       textColor: Colors.white);
                          // } else {

                          //userModelProvider.changeName(_nameTxtController.text);
                          //userModelProvider.changeImg(imageFile);
                          Navigator.of(context).pushReplacementNamed(RouteNames.homeScreen);
                          //}
                        }),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 18,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog dateAlertDialog() {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            child: Text(
              'Cancel',
              style: TextStyle(color: MyAppTheme.searchColor, fontFamily: 'Ubuntu', fontSize: 16),
            )),
        TextButton(
            onPressed: (() {
              var userModelProvider = Provider.of<UserModelProvider>(context, listen: false);
              userModelProvider.changeBrithday(DateTime(yearList[selectedYearIndex.value],
                  monthList[selectedMonthIndex.value], dayList[selectedDayIndex.value]));
              Navigator.of(context).pop();
            }),
            child: Text(
              'OK',
              style:
                  TextStyle(color: MyAppTheme.secondaryColor, fontFamily: 'Ubuntu', fontSize: 18),
            ))
      ],
      title: Text(
        '',
        style: TextStyle(color: MyAppTheme.primaryTxtColor, fontFamily: 'Ubuntu', fontSize: 25),
      ),
      content: SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Day',
                  style: TextStyle(color: MyAppTheme.primaryTxtColor, fontFamily: 'Ubuntu'),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 40,
                  height: 100,
                  child: ValueListenableBuilder(
                    valueListenable: selectedYearIndex,
                    builder: (BuildContext context, dynamic value, Widget? child) {
                      return ValueListenableBuilder(
                        valueListenable: selectedMonthIndex,
                        builder: (BuildContext context, dynamic value, Widget? child) {
                          //declare local vars to avoid duplicate code
                          int year = yearList[selectedYearIndex.value];
                          int month = monthList[selectedMonthIndex.value];

                          return PageView.builder(
                            physics: const ClampingScrollPhysics(),
                            allowImplicitScrolling: true,
                            scrollDirection: Axis.vertical,
                            itemCount: (year % 4 == 0 && month == 2)
                                ? 29
                                : (month == 2)
                                    ? 28
                                    : (month == 4 || month == 6 || month == 9 || month == 11)
                                        ? 30
                                        : 31,
                            controller: _pageControllerDay,
                            itemBuilder: ((context, index) {
                              return ValueListenableBuilder(
                                  valueListenable: selectedDayIndex,
                                  builder: ((context, value, child) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text(dayList[index].toString(),
                                          style: TextStyle(
                                            color: selectedDayIndex.value == index
                                                ? MyAppTheme.primaryTxtColor
                                                : MyAppTheme.disableColor,
                                            fontSize: selectedDayIndex.value == index ? 20 : 12,
                                          )),
                                    );
                                  }));
                            }),
                            onPageChanged: (value) {
                              selectedDayIndex.value = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            VerticalDivider(
              color: MyAppTheme.primaryTxtColor,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Month',
                  style: TextStyle(color: MyAppTheme.primaryTxtColor, fontFamily: 'Ubuntu'),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 40,
                  height: 100,
                  child: PageView.builder(
                    physics: const ClampingScrollPhysics(),
                    allowImplicitScrolling: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 12,
                    controller: _pageControllerMonth,
                    itemBuilder: ((context, index) {
                      return ValueListenableBuilder(
                          valueListenable: selectedMonthIndex,
                          builder: ((context, value, child) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(monthList[index].toString(),
                                  style: TextStyle(
                                    color: selectedMonthIndex.value == index
                                        ? MyAppTheme.primaryTxtColor
                                        : MyAppTheme.disableColor,
                                    fontSize: selectedMonthIndex.value == index ? 20 : 12,
                                  )),
                            );
                          }));
                    }),
                    onPageChanged: (value) {
                      previousMonthIndex = selectedDayIndex.value;
                      selectedMonthIndex.value = value;
                      //to adjust selectedDayIndex with month changing
                      if (previousMonthIndex != 3 &&
                          previousMonthIndex != 5 &&
                          previousMonthIndex != 8 &&
                          previousMonthIndex != 10 &&
                          previousMonthIndex != 1) {
                        if ((selectedMonthIndex.value == 3 ||
                                selectedMonthIndex.value == 5 ||
                                selectedMonthIndex.value == 8 ||
                                selectedMonthIndex.value == 10) &&
                            selectedDayIndex.value == 30) {
                          selectedDayIndex.value -= 1;
                        } else if (selectedMonthIndex.value == 1) {
                          if (selectedDayIndex.value == 30) {
                            yearList[selectedYearIndex.value] % 4 == 0
                                ? selectedDayIndex.value -= 2
                                : selectedDayIndex.value -= 3;
                          } else if (selectedDayIndex.value == 29) {
                            yearList[selectedYearIndex.value] % 4 == 0
                                ? selectedDayIndex.value -= 1
                                : selectedDayIndex.value -= 2;
                          }
                        }
                      }
                    },
                  ),
                )
              ],
            ),
            VerticalDivider(
              color: MyAppTheme.primaryTxtColor,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Year',
                  style: TextStyle(color: MyAppTheme.primaryTxtColor, fontFamily: 'Ubuntu'),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 60,
                  height: 100,
                  child: PageView.builder(
                    physics: const ClampingScrollPhysics(),
                    allowImplicitScrolling: true,
                    scrollDirection: Axis.vertical,
                    itemCount: yearList.length,
                    controller: _pageControllerYear,
                    itemBuilder: ((context, index) {
                      return ValueListenableBuilder(
                          valueListenable: selectedYearIndex,
                          builder: ((context, value, child) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(yearList[index].toString(),
                                  style: TextStyle(
                                    color: selectedYearIndex.value == index
                                        ? MyAppTheme.primaryTxtColor
                                        : MyAppTheme.disableColor,
                                    fontSize: selectedYearIndex.value == index ? 20 : 12,
                                  )),
                            );
                          }));
                    }),
                    onPageChanged: (value) {
                      selectedYearIndex.value = value;
                      //for changing day from 29 to 28 when user change from leap year to not
                      if (selectedMonthIndex.value == 1 &&
                          selectedDayIndex.value == 28 &&
                          yearList[selectedYearIndex.value] % 4 != 0) {
                        selectedDayIndex.value -= 1;
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void adjustDateAlerdialogToDob() {
    var userModelProvider = Provider.of<UserModelProvider>(context, listen: false);
    int selectedDay = dayList.indexOf(userModelProvider.userModel.birthday.day);
    selectedDayIndex.value = selectedDay;
    _pageControllerDay = PageController(viewportFraction: 0.4, initialPage: selectedDay);

    int selectedMonth = monthList.indexOf(userModelProvider.userModel.birthday.month);
    selectedMonthIndex.value = selectedMonth;
    _pageControllerMonth = PageController(viewportFraction: 0.4, initialPage: selectedMonth);

    int selectedYear = yearList.indexOf(userModelProvider.userModel.birthday.year);
    selectedYearIndex.value = selectedYear;
    _pageControllerYear = PageController(viewportFraction: 0.4, initialPage: selectedYear);
  }

  _getUserImage() async {
    ImagePicker imagePicker = ImagePicker();
    //PickedFile? file = await ImagePicker().getVideo(source: ImageSource.gallery);
    final PickedFile? pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = io.File(pickedFile.path);
      imageAlreadySelected.value = true;
    }
  }

  //
}
