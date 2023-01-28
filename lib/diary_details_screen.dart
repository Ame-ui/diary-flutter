import 'package:diary/model/diary_model.dart';
import 'package:diary/resources/mood_emote.dart';
import 'package:diary/resources/my_app_theme.dart';
import 'package:diary/route/route_names.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.diaryModel});
  final DiaryModel diaryModel;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: checkMoodColor(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              customAppBar(),
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(widget.diaryModel.subTitle),
                ),
              ))
            ],
          ),
          floatingActionButton: floatingActionBtn(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  Padding floatingActionBtn() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'star',
            backgroundColor: MyAppTheme.searchColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: (() {}),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_border,
                  color: MyAppTheme.itemBgColor,
                ),
                const SizedBox(height: 5),
                Text(
                  'Star',
                  style:
                      TextStyle(color: MyAppTheme.itemBgColor, fontFamily: 'Ubuntu', fontSize: 10),
                )
              ],
            ),
          ),
          FloatingActionButton(
            heroTag: 'edit',
            backgroundColor: MyAppTheme.searchColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: (() {
              Navigator.of(context)
                  .pushNamed(RouteNames.diaryEditScreen, arguments: widget.diaryModel);
            }),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  color: MyAppTheme.itemBgColor,
                ),
                const SizedBox(height: 5),
                Text(
                  'Edit',
                  style:
                      TextStyle(color: MyAppTheme.itemBgColor, fontFamily: 'Ubuntu', fontSize: 10),
                )
              ],
            ),
          ),
          FloatingActionButton(
            heroTag: 'backup',
            backgroundColor: MyAppTheme.searchColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: (() {}),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.download,
                  color: MyAppTheme.itemBgColor,
                ),
                const SizedBox(height: 5),
                Text(
                  'Backup',
                  style:
                      TextStyle(color: MyAppTheme.itemBgColor, fontFamily: 'Ubuntu', fontSize: 10),
                )
              ],
            ),
          ),
          FloatingActionButton(
            heroTag: 'delete',
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: (() {
              Navigator.of(context).pushNamed(RouteNames.tagsEditScreen);
            }),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: MyAppTheme.itemBgColor,
                ),
                const SizedBox(height: 5),
                Text(
                  'Delete',
                  style:
                      TextStyle(color: MyAppTheme.itemBgColor, fontFamily: 'Ubuntu', fontSize: 10),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container customAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 3, color: MyAppTheme.disableColor, blurStyle: BlurStyle.outer)
          ],
          color: checkMoodColor().withOpacity(0.3),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: (() {}),
                icon: const Icon(Icons.keyboard_arrow_left),
                color: MyAppTheme.primaryTxtColor,
                iconSize: 30,
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  widget.diaryModel.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: MyAppTheme.primaryTxtColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                      fontSize: 22),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              checkMood(widget.diaryModel.mood),
              const SizedBox(width: 15),
              Text(
                DateFormat('MMM d').format(widget.diaryModel.date),
                style: TextStyle(
                    color: MyAppTheme.secondaryTxtColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Ubuntu',
                    fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }

  Icon checkMood(String mood) {
    IconData moodIcon = MoodEmote.normal_emote;
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
      color: MyAppTheme.secondaryTxtColor,
      size: 22,
    );
    return selectedIcon;
  }

  Color checkMoodColor() {
    String moodData = widget.diaryModel.mood;
    return (moodData == 'joyful'
        ? MyAppTheme.moodJoyfulColor
        : moodData == 'happy'
            ? MyAppTheme.moodHappyColor
            : moodData == 'normal'
                ? MyAppTheme.moodNormalColor
                : moodData == 'sad'
                    ? MyAppTheme.moodSadColor
                    : moodData == 'angry'
                        ? MyAppTheme.moodAngryColor
                        : const Color(0xff808080));
  }
}
