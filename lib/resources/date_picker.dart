import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'my_app_theme.dart';

class DateNumberPicker {
  //BuildContext context;
  //DateNumberPicker({required this.context});

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

  List<int> _addingDMY(int start, int end) {
    List<int> tempList = [];
    while (start <= end) {
      tempList.add(start);
      start += 1;
    }
    return tempList;
  }

  void _adjustDateAlerdialogToDob(DateTime date) {
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

  Future<DateTime> _showDatePicker(BuildContext context, DateTime currentDate) {
    dayList = _addingDMY(1, 31);
    monthList = _addingDMY(1, 12);
    yearList = _addingDMY(1922, DateTime.now().year);
    previousMonthIndex = monthList.indexOf(currentDate.month);
    _adjustDateAlerdialogToDob(currentDate);

    DateTime selectedDate = DateTime(2000, 2, 20);
    Future<DateTime> returnDate;
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: MyAppTheme.searchColor, fontFamily: 'Ubuntu', fontSize: 16),
                    )),
                TextButton(
                    onPressed: (() {
                      //var userModelProvider = Provider.of<UserModelProvider>(context, listen: false);
                      // userModelProvider.changeBrithday(DateTime(yearList[selectedYearIndex.value],
                      //     monthList[selectedMonthIndex.value], dayList[selectedDayIndex.value]));
                      Navigator.of(context).pop();
                      selectedDate = DateTime(yearList[selectedYearIndex.value],
                          monthList[selectedMonthIndex.value], dayList[selectedDayIndex.value]);
                      //return selectedDate;
                    }),
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: MyAppTheme.secondaryColor, fontFamily: 'Ubuntu', fontSize: 18),
                    ))
              ],
              title: Text(
                '',
                style: TextStyle(
                    color: MyAppTheme.primaryTxtColor, fontFamily: 'Ubuntu', fontSize: 25),
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
                                            : (month == 4 ||
                                                    month == 6 ||
                                                    month == 9 ||
                                                    month == 11)
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
                                                    fontSize:
                                                        selectedDayIndex.value == index ? 20 : 12,
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
            )));
    returnDate = selectedDate as Future<DateTime>;
    return returnDate;
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////