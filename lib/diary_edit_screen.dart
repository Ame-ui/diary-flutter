import 'dart:ffi';
import 'dart:io' as io;

import 'package:diary/model/diary_model.dart';
import 'package:diary/provider/diary_content_provider.dart';
import 'package:diary/provider/user_model_provider.dart';
import 'package:diary/resources/date_picker.dart';
import 'package:diary/resources/mood_emote.dart';
import 'package:diary/resources/my_app_theme.dart';
import 'package:diary/route/route_names.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class DiaryEdit extends StatefulWidget {
  const DiaryEdit({super.key, required this.selectedDm});
  final DiaryModel selectedDm;
  @override
  State<DiaryEdit> createState() => _DiaryEditState();
}

class _DiaryEditState extends State<DiaryEdit> {
  TextEditingController _controllerTitle = TextEditingController();
  ValueNotifier<bool> isTextClicked = ValueNotifier(false);
  ValueNotifier<bool> isOtherClicked = ValueNotifier(false);
  ValueNotifier<int> selectedFontSize = ValueNotifier(8);
  ValueNotifier<String> selectedFont = ValueNotifier('Ubuntu');
  DateTime selectedDate = DateTime.now();
  var selectedMood = '';
  io.File contentImg = io.File('');
  io.File contentVideo = io.File('');
  PageController _pageControllerDay = PageController(viewportFraction: 0.4);
  PageController _pageControllerMonth = PageController(viewportFraction: 0.4);
  PageController _pageControllerYear = PageController(viewportFraction: 0.4);

  ValueNotifier<int> selectedDayIndex = ValueNotifier<int>(0);
  ValueNotifier<int> selectedMonthIndex = ValueNotifier<int>(0);
  ValueNotifier<int> selectedYearIndex = ValueNotifier<int>(0);

  int previousMonthIndex = 0;
  List<int> dayList = [];
  List<int> monthList = [];
  List<int> yearList = [];

  List<int> addingDMY(int start, int end) {
    List<int> tempList = [];
    while (start <= end) {
      tempList.add(start);
      start += 1;
    }
    return tempList;
  }

  void adjustDateAlerdialogToDate(DateTime date) {
    int selectedDay = dayList.indexOf(date.day);
    selectedDayIndex.value = selectedDay;
    _pageControllerDay = PageController(viewportFraction: 0.4, initialPage: selectedDay);

    int selectedMonth = monthList.indexOf(date.month);
    selectedMonthIndex.value = selectedMonth;
    _pageControllerMonth = PageController(viewportFraction: 0.4, initialPage: selectedMonth);

    int selectedYear = yearList.indexOf(date.year);
    selectedYearIndex.value = selectedYear;
    _pageControllerYear = PageController(viewportFraction: 0.4, initialPage: selectedYear);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerTitle.dispose();
    isTextClicked.dispose();
    selectedDayIndex.dispose();
    selectedMonthIndex.dispose();
    selectedYearIndex.dispose();
    _pageControllerDay.dispose();
    _pageControllerMonth.dispose();
    _pageControllerYear.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _controllerTitle.text = widget.selectedDm.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Fluttertoast.showToast(msg: 'build');

    //initializing day, month, year
    dayList = addingDMY(1, 31);
    monthList = addingDMY(1, 12);
    yearList = addingDMY(1922, DateTime.now().year);
    previousMonthIndex = monthList.indexOf(widget.selectedDm.date.month);

    return SafeArea(
      child: Scaffold(
          backgroundColor: MyAppTheme.bgColor,
          body: Column(children: [
            editAppBar(),
            Expanded(child: content()),
            bottomBar(),
          ])),
    );
  }

  Container editAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: MyAppTheme.disableColor, blurRadius: 3)],
          color: MyAppTheme.itemBgColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: Flex(
        //crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                  icon: const Icon(Icons.keyboard_arrow_left),
                  color: MyAppTheme.primaryTxtColor,
                  iconSize: 30,
                ),
                const SizedBox(width: 5),
                Expanded(
                    child: TextField(
                  autocorrect: false,
                  controller: _controllerTitle,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(color: MyAppTheme.disableColor),
                  ),
                  style: TextStyle(
                      color: MyAppTheme.primaryTxtColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                      fontSize: 22),
                )),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: (() =>
                          showDialog(context: context, builder: ((context) => showMoodPicker()))),
                      child: Row(
                        children: [
                          checkMood(widget.selectedDm.mood),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: MyAppTheme.secondaryTxtColor,
                            size: 25,
                          ),
                        ],
                      ),
                    )),
                InkWell(
                  onTap: (() {
                    adjustDateAlerdialogToDate(selectedDate);
                    showDialog(context: context, builder: ((context) => dateAlertDialog()));
                  }),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('MMM d').format(selectedDate),
                        style: TextStyle(
                            color: MyAppTheme.secondaryTxtColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Ubuntu',
                            fontSize: 18),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: MyAppTheme.secondaryTxtColor,
                        size: 25,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: (() {
                    Navigator.of(context).pushNamed(RouteNames.homeScreen);
                  }),
                  icon: const Icon(Icons.check),
                  color: MyAppTheme.primaryTxtColor,
                  iconSize: 30,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Icon checkMood(String mood) {
    IconData moodIcon = MoodEmote.normal_emote;
    Color moodColor = MyAppTheme.secondaryTxtColor;
    switch (mood) {
      case 'joyful':
        moodIcon = MoodEmote.joyful_emote;
        break;
      case 'happy':
        moodIcon = MoodEmote.happy_emote;
        break;
      case 'normal':
        moodIcon = MoodEmote.normal_emote;
        break;

      case 'sad':
        moodIcon = MoodEmote.sad_emote;
        break;
      case 'angry':
        moodIcon = MoodEmote.angry_emote;
        break;
    }
    Icon selectedIcon = Icon(
      moodIcon,
      color: moodColor,
      size: 22,
    );
    return selectedIcon;
  }

  AlertDialog showMoodPicker() {
    var moodDropdownName = ['Joyful', 'Happy', 'Normal', 'Sad', 'Angry'];
    //int previousIndex;
    List moodDropdownIcon = [
      MoodEmote.joyful_emote,
      MoodEmote.happy_emote,
      MoodEmote.normal_emote,
      MoodEmote.sad_emote,
      MoodEmote.angry_emote
    ];
    return AlertDialog(
      content: SizedBox(
        height: 350,
        //width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'How is your day?',
              style: TextStyle(
                  color: MyAppTheme.primaryTxtColor,
                  fontFamily: 'Ubuntu',
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Divider(
              color: MyAppTheme.primaryTxtColor,
              thickness: 2,
            ),
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                  itemCount: 5,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) => ListTile(
                        onTap: () {
                          Fluttertoast.showToast(msg: moodDropdownName[index]);
                        },
                        leading: Icon(
                          moodDropdownIcon[index],
                          color: MyAppTheme.primaryTxtColor,
                        ),
                        title: Text(
                          moodDropdownName[index],
                          style: TextStyle(color: MyAppTheme.primaryTxtColor, fontSize: 18),
                        ),
                      ))),
            )
          ],
        ),
      ),
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
              Navigator.of(context).pop();
            }),
            child: Text(
              'OK',
              style:
                  TextStyle(color: MyAppTheme.secondaryColor, fontFamily: 'Ubuntu', fontSize: 18),
            ))
      ],
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
              setState(() {
                selectedDate = DateTime(yearList[selectedYearIndex.value],
                    monthList[selectedMonthIndex.value], dayList[selectedDayIndex.value]);
              });
              Fluttertoast.showToast(msg: 'Date updated');
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

  Stack content() {
    //var contentListProvider = Provider.of<DiaryContentProvider>(context, listen: false);
    return Stack(alignment: const Alignment(1, 1), children: [
      Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Consumer<DiaryContentProvider>(
              builder: ((context, value, child) => ListView.builder(
                  itemCount: value.contentList.length,
                  itemBuilder: ((context, index) {
                    return value.contentList[index];
                  }))))),
      undoRedoBtn(),
    ]);
  }

  _getContentImage() async {
    ImagePicker imagePicker = ImagePicker();
    //PickedFile? file = await ImagePicker().getVideo(source: ImageSource.gallery);
    var prov = Provider.of<DiaryContentProvider>(context, listen: false);
    final PickedFile? pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      contentImg = io.File(pickedFile.path);
      prov.addImage(contentImg);
    }
  }

  _getContentVideo() async {
    ImagePicker imagePicker = ImagePicker();
    //PickedFile? file = await ImagePicker().getVideo(source: ImageSource.gallery);
    var prov = Provider.of<DiaryContentProvider>(context, listen: false);

    final PickedFile? pickedFile = await imagePicker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      contentVideo = io.File(pickedFile.path);
      prov.addVideo(contentVideo);
    }
  }

  Column bottomBar() {
    return Column(
      children: [
        Container(
          //height: 80,
          decoration: BoxDecoration(color: MyAppTheme.itemBgColor, boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(0, -1), blurRadius: 3),
          ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder(
                valueListenable: isOtherClicked,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return ValueListenableBuilder(
                    valueListenable: isTextClicked,
                    builder: (BuildContext context, dynamic value, Widget? child) {
                      return Visibility(
                          visible: isTextClicked.value || isOtherClicked.value,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Visibility(visible: isTextClicked.value, child: textContainer()),
                              Visibility(
                                visible: isOtherClicked.value,
                                child: otherContainer(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                endIndent: 5,
                                indent: 5,
                                color: Colors.grey,
                              )
                            ],
                          ));
                    },
                  );
                },
              ),
              bottomItems()
            ],
          ),
        ),
      ],
    );
  }

  Padding bottomItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: (() {
              // var contentP = Provider.of<DiaryContentProvider>(context, listen: false);
              // contentP._addTextField();
              isTextClicked.value = !isTextClicked.value;
              isOtherClicked.value = false;
            }),
            child: SizedBox(
              width: 100,
              child: ValueListenableBuilder(
                valueListenable: isTextClicked,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Column(children: [
                    Icon(Icons.text_fields,
                        color:
                            isTextClicked.value ? MyAppTheme.primaryColor : MyAppTheme.searchColor),
                    const SizedBox(height: 5),
                    Text('Text',
                        style: TextStyle(
                            color: isTextClicked.value
                                ? MyAppTheme.primaryColor
                                : MyAppTheme.searchColor,
                            fontSize: 12))
                  ]);
                },
              ),
            ),
          ),
          InkWell(
            onTap: (() {
              isOtherClicked.value = !isOtherClicked.value;
              isTextClicked.value = false;
            }),
            child: SizedBox(
              width: 100,
              child: ValueListenableBuilder(
                valueListenable: isOtherClicked,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Column(
                    children: [
                      Icon(Icons.category_rounded,
                          color: isOtherClicked.value
                              ? MyAppTheme.primaryColor
                              : MyAppTheme.searchColor),
                      const SizedBox(height: 5),
                      Text('Other',
                          style: TextStyle(
                              color: isOtherClicked.value
                                  ? MyAppTheme.primaryColor
                                  : MyAppTheme.searchColor,
                              fontSize: 12))
                    ],
                  );
                },
              ),
            ),
          ),
          InkWell(
            onTap: (() {
              Navigator.of(context).pushNamed(RouteNames.tagsEditScreen);
            }),
            child: SizedBox(
              width: 100,
              child: Column(children: [
                Icon(Ionicons.pricetag, color: MyAppTheme.searchColor),
                const SizedBox(height: 5),
                Text('Tag', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 12))
              ]),
            ),
          )
        ],
      ),
    );
  }

  Row otherContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
            onTap: (() {
              _getContentImage();
            }),
            child: SizedBox(
              width: 100,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.image, color: MyAppTheme.searchColor),
                ),
                Text('Image', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 10))
              ]),
            )),
        InkWell(
            onTap: (() {
              _getContentVideo();
            }),
            child: SizedBox(
              width: 100,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.play_circle_fill_rounded, color: MyAppTheme.searchColor),
                ),
                Text('Video', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 10))
              ]),
            )),
        InkWell(
            onTap: (() {
              Fluttertoast.showToast(msg: 'Feature unavailable');
            }),
            child: SizedBox(
              width: 100,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.audiotrack_rounded, color: MyAppTheme.searchColor),
                ),
                Text('Audio', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 10))
              ]),
            )),
        InkWell(
            onTap: (() {
              Fluttertoast.showToast(msg: 'Feature unavailable');
            }),
            child: SizedBox(
              width: 100,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.file_present_rounded, color: MyAppTheme.searchColor),
                ),
                Text('File', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 10))
              ]),
            )),
      ],
    );
  }

  Padding textContainer() {
    var fontSizeList = [8, 10, 12, 16, 18, 20];
    var fontList = ['Ubuntu', 'Font A', 'Font B', 'Font C', 'Font D'];
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: selectedFont,
                  builder: (BuildContext context, dynamic value, Widget? child) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton(
                          style: TextStyle(color: MyAppTheme.searchColor, fontSize: 20),
                          hint: Text(selectedFont.value.toString()),
                          items: fontList
                              .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                              .toList(),
                          onChanged: ((value) {
                            selectedFont.value = value as String;
                          })),
                    );
                  },
                ),
                Text('Font', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 10))
              ],
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: selectedFontSize,
                  builder: (BuildContext context, dynamic value, Widget? child) {
                    return Container(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            style: TextStyle(color: MyAppTheme.searchColor, fontSize: 20),
                            hint: Text(selectedFontSize.value.toString()),
                            items: fontSizeList
                                .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                                .toList(),
                            onChanged: ((value) {
                              selectedFontSize.value = value as int;
                            })),
                      ),
                    );
                  },
                ),
                Text('Size', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 10))
              ],
            ),
            const SizedBox(width: 5),
            Column(children: [
              IconButton(
                  onPressed: (() {
                    Fluttertoast.showToast(msg: 'Feature unavailable');
                  }),
                  icon: const Icon(Icons.color_lens),
                  color: MyAppTheme.searchColor),
              Text('Color', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 10))
            ]),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: (() {
                          Fluttertoast.showToast(msg: 'Feature unavailable');
                        }),
                        icon: const Icon(Icons.format_bold),
                        color: MyAppTheme.searchColor),
                    IconButton(
                        onPressed: (() {
                          Fluttertoast.showToast(msg: 'Feature unavailable');
                        }),
                        icon: const Icon(Icons.format_italic),
                        color: MyAppTheme.searchColor),
                    IconButton(
                        onPressed: (() {
                          Fluttertoast.showToast(msg: 'Feature unavailable');
                        }),
                        icon: const Icon(Icons.format_underline),
                        color: MyAppTheme.searchColor),
                  ],
                ),
                Text('Text style', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 10))
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: (() {
                          Fluttertoast.showToast(msg: 'Feature unavailable');
                        }),
                        icon: const Icon(Icons.format_align_left_rounded),
                        color: MyAppTheme.searchColor),
                    IconButton(
                        onPressed: (() {
                          Fluttertoast.showToast(msg: 'Feature unavailable');
                        }),
                        icon: const Icon(Icons.format_align_center_rounded),
                        color: MyAppTheme.searchColor),
                    IconButton(
                        onPressed: (() {
                          Fluttertoast.showToast(msg: 'Feature unavailable');
                        }),
                        icon: const Icon(Icons.format_align_right_rounded),
                        color: MyAppTheme.searchColor),
                  ],
                ),
                Text('Text align', style: TextStyle(color: MyAppTheme.searchColor, fontSize: 10))
              ],
            )
          ],
        ),
      ),
    );
  }

  Container undoRedoBtn() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, right: 15),
      decoration: BoxDecoration(
          color: MyAppTheme.itemBgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 3)]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: (() {
              Fluttertoast.showToast(msg: 'Feature unavailable');
            }),
            icon: const Icon(Icons.undo),
            color: MyAppTheme.searchColor,
          ),
          IconButton(
            onPressed: (() {
              Fluttertoast.showToast(msg: 'Feature unavailable');
            }),
            icon: const Icon(Icons.redo),
            color: MyAppTheme.searchColor,
          )
        ],
      ),
    );
  }
}
