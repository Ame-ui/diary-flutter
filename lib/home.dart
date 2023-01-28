import 'package:diary/provider/user_model_provider.dart';
import 'package:diary/resources/diary_listtile.dart';
import 'package:diary/model/diary_model.dart';
import 'package:diary/model/user_model.dart';
import 'package:diary/resources/mood_emote.dart';
import 'package:diary/resources/my_app_theme.dart';
import 'package:diary/route/route_names.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat dateFormatter = DateFormat('MMM d, y');
  ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);

  final settingIconlist = [
    Icons.brush,
    Icons.notifications,
    Icons.cloud,
    Icons.shield,
    Icons.star,
    Icons.delete
  ];
  final settingNameList = ['Theme', 'Reminder', 'Backup', 'Security', 'Starred', 'Deleted'];
  final moodEmoteList = [
    MoodEmote.joyful_emote,
    MoodEmote.happy_emote,
    MoodEmote.normal_emote,
    MoodEmote.sad_emote,
    MoodEmote.angry_emote
  ];
  final moodColorList = [
    MyAppTheme.moodJoyfulColor,
    MyAppTheme.moodHappyColor,
    MyAppTheme.moodNormalColor,
    MyAppTheme.moodSadColor,
    MyAppTheme.moodAngryColor
  ];
  final moodCountList = [22, 20, 22, 11, 14];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyAppTheme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: MyAppTheme.bgColor,
          key: _scaffoldKey,
          drawer: menuDrawer(),
          body: ValueListenableBuilder(
            valueListenable: pageIndexNotifier,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return pageIndexNotifier.value == 0
                  ? homePage()
                  : pageIndexNotifier.value == 1
                      ? calendarPage()
                      : pageIndexNotifier.value == 2
                          ? moodPage()
                          : tagPage();
            },
          ),
          bottomNavigationBar: bottomNavigationBar(),
          floatingActionButton: floatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  Drawer menuDrawer() {
    var userModelProvider = Provider.of<UserModelProvider>(context, listen: false);
    return Drawer(
      backgroundColor: MyAppTheme.bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
              decoration: BoxDecoration(
                  color: MyAppTheme.itemBgColor,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: (() => Navigator.of(context).pop()),
                    icon: Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: MyAppTheme.primaryTxtColor,
                    ),
                    iconSize: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(userModelProvider.userModel.imgFile),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModelProvider.userModel.name,
                            style: TextStyle(
                                color: MyAppTheme.primaryTxtColor,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Age:',
                                    style: TextStyle(
                                        color: MyAppTheme.primaryTxtColor,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 14),
                                  ),
                                  Text(
                                    (DateTime.now().year -
                                            userModelProvider.userModel.birthday.year)
                                        .toString(),
                                    style: TextStyle(
                                        color: MyAppTheme.primaryTxtColor,
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Gender:',
                                    style: TextStyle(
                                        color: MyAppTheme.primaryTxtColor,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 14),
                                  ),
                                  Text(
                                    userModelProvider.userModel.gender.toString(),
                                    style: TextStyle(
                                        color: MyAppTheme.primaryTxtColor,
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(3)),
                              border: Border.all(
                                  color: MyAppTheme.primaryTxtColor,
                                  width: 1.5,
                                  strokeAlign: StrokeAlign.center,
                                  style: BorderStyle.solid)),
                          child: Icon(
                            Icons.edit,
                            color: MyAppTheme.primaryTxtColor,
                            size: 16,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '121',
                            style: TextStyle(
                                color: MyAppTheme.primaryTxtColor,
                                fontFamily: 'Ubuntu',
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Days',
                            style: TextStyle(
                              color: MyAppTheme.primaryTxtColor,
                              fontFamily: 'Ubuntu',
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          Text(
                            '140',
                            style: TextStyle(
                                color: MyAppTheme.primaryTxtColor,
                                fontFamily: 'Ubuntu',
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Entries',
                            style: TextStyle(
                              color: MyAppTheme.primaryTxtColor,
                              fontFamily: 'Ubuntu',
                              fontSize: 18,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Tags',
                    style: TextStyle(
                        color: MyAppTheme.primaryTxtColor,
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 25,
                    //width: double.maxFinite,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 11,
                        addRepaintBoundaries: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          return Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: MyAppTheme.searchColor.withOpacity(0.3),
                              border: Border.all(color: MyAppTheme.primaryTxtColor, width: 1),
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              'item: $index',
                              style: TextStyle(
                                  color: MyAppTheme.secondaryTxtColor,
                                  fontFamily: 'Ubuntu',
                                  fontSize: 12),
                            ),
                          );
                        })),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Moods',
                    style: TextStyle(
                        color: MyAppTheme.primaryTxtColor,
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 25,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        addRepaintBoundaries: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          return Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: moodColorList[index],
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    moodEmoteList[index],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    moodCountList[index].toString(),
                                    style: TextStyle(
                                        color: MyAppTheme.primaryTxtColor,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                ],
                              ));
                        })),
                  ),
                  const SizedBox(height: 25),
                ],
              )),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                    itemCount: 6,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return InkWell(
                        onTap: (() {
                          settingNavigationPush(index);
                        }),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Row(
                            children: [
                              Icon(
                                settingIconlist[index],
                                color: MyAppTheme.primaryTxtColor,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                settingNameList[index],
                                style: TextStyle(
                                    color: MyAppTheme.primaryTxtColor,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      );
                    }))),
          )
        ],
      ),
    );
  }

  void settingNavigationPush(int index) {
    String screenName;
    switch (index) {
      case 0:
        screenName = RouteNames.themeScreen;
        break;
      case 1:
        screenName = RouteNames.reminderScreen;
        break;
      case 2:
        screenName = RouteNames.backupScreen;
        break;
      case 3:
        screenName = RouteNames.securityScreen;
        break;
      case 4:
        screenName = RouteNames.starredScreen;
        break;
      case 5:
        screenName = RouteNames.deletedScreen;
        break;
      default:
        screenName = RouteNames.homeScreen;
    }
    Navigator.of(context).pushNamed(screenName);
  }

  Column homePage() {
    var userModelProvider = Provider.of<UserModelProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: MyAppTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (() {
                      _scaffoldKey.currentState?.openDrawer();
                    }),
                    iconSize: 30,
                    icon: const Icon(Icons.menu_rounded),
                    color: MyAppTheme.primaryTxtColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: MyAppTheme.bgColor,
                            borderRadius: const BorderRadius.all(Radius.circular(15))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.search,
                              size: 20,
                              color: MyAppTheme.searchColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Search',
                              style: TextStyle(
                                  color: MyAppTheme.searchColor,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<UserModelProvider>(
                        builder: ((context, value, child) => Text(
                              'Hello ${value.userModel.name},',
                              style: TextStyle(
                                  color: MyAppTheme.primaryTxtColor,
                                  fontFamily: 'Ubuntu',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ))),
                    const SizedBox(height: 10),
                    Text(
                      'Hope your day was going well.',
                      style: TextStyle(
                          color: MyAppTheme.primaryTxtColor,
                          fontFamily: 'Ubuntu',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      dateFormatter.format(DateTime.now()),
                      style: TextStyle(
                          color: MyAppTheme.secondaryTxtColor,
                          fontFamily: 'Ubuntu',
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Today',
                        style: TextStyle(color: MyAppTheme.secondaryColor, fontFamily: 'Ubuntu'),
                      )),
                  DiaryListtile(
                      diaryModel: DiaryModel(
                          title: 'Interview day',
                          subTitle:
                              'aaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaa|\naaBBBB\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\na\naaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\na',
                          mood: 'joyful',
                          date: DateTime.now(),
                          imgFile: [])),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Yesterday',
                        style: TextStyle(color: MyAppTheme.secondaryColor, fontFamily: 'Ubuntu'),
                      )),
                  DiaryListtile(
                      diaryModel: DiaryModel(
                          title: 'Interview day',
                          subTitle:
                              'aaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaa|\naaBBBBBBBBBBBBBBB',
                          mood: 'angry',
                          date: DateTime(
                              DateTime.now().year, DateTime.now().month, (DateTime.now().day - 1)),
                          imgFile: [])),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Column calendarPage() {
    return Column();
  }

  Column moodPage() {
    return Column();
  }

  Column tagPage() {
    return Column();
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(
        backgroundColor: MyAppTheme.primaryColor,
        onPressed: (() {}),
        child: Icon(
          Icons.add,
          color: MyAppTheme.itemBgColor,
        ));
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
        showUnselectedLabels: true,
        backgroundColor: MyAppTheme.itemBgColor,
        currentIndex: pageIndexNotifier.value,
        selectedItemColor: MyAppTheme.primaryColor,
        unselectedItemColor: MyAppTheme.disableColor,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          pageIndexNotifier.value = value;
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month_rounded,
              ),
              label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.emoji_emotions_rounded,
              ),
              label: 'Moods'),
          BottomNavigationBarItem(
              icon: Icon(
                Ionicons.pricetag,
              ),
              label: 'Tags')
        ]);
  }
}
