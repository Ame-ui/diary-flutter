import 'package:diary/model/diary_model.dart';
import 'package:diary/resources/mood_emote.dart';
import 'package:diary/resources/my_app_theme.dart';
import 'package:diary/route/route_names.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryListtile extends StatefulWidget {
  const DiaryListtile({super.key, required this.diaryModel});
  final DiaryModel diaryModel;

  @override
  State<DiaryListtile> createState() => _DiaryListtileState();
}

class _DiaryListtileState extends State<DiaryListtile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(RouteNames.diaryDetailsScreen, arguments: widget.diaryModel);
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: checkMoodColor(),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMM d, E').format(widget.diaryModel.date),
                        style: TextStyle(
                            color: MyAppTheme.secondaryTxtColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Ubuntu',
                            fontSize: 14),
                      ),
                      const SizedBox(width: 10),
                      checkMood(widget.diaryModel.mood)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.diaryModel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyAppTheme.primaryTxtColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu',
                        fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      widget.diaryModel.subTitle,
                      style: TextStyle(
                          color: MyAppTheme.secondaryTxtColor, fontFamily: 'Ubuntu', fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Tags:',
                        style: TextStyle(
                            color: MyAppTheme.secondaryTxtColor,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w600,
                            fontSize: 10),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        height: 25,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            addRepaintBoundaries: false,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              return (index == 3)
                                  ? Row(
                                      children: [
                                        Icon(Icons.circle, size: 4, color: MyAppTheme.disableColor),
                                        const SizedBox(width: 3),
                                        Icon(Icons.circle, size: 4, color: MyAppTheme.disableColor),
                                        const SizedBox(width: 3),
                                        Icon(Icons.circle, size: 4, color: MyAppTheme.disableColor),
                                      ],
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: MyAppTheme.searchColor.withOpacity(0.3),
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      ),
                                      child: Text(
                                        'item: $index',
                                        style: TextStyle(
                                            color: MyAppTheme.secondaryTxtColor,
                                            fontFamily: 'Ubuntu',
                                            fontSize: 10),
                                      ),
                                    );
                            })),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '10:30',
                    style: TextStyle(
                        color: MyAppTheme.secondaryTxtColor, fontFamily: 'Ubuntu', fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  widget.diaryModel.imgFile.isEmpty
                      ? Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color: MyAppTheme.inactiveDotColor,
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              image: const DecorationImage(
                                  image: AssetImage('assets/diary_logo.png'), fit: BoxFit.cover)),
                        )
                      : Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              image: DecorationImage(
                                  image: FileImage(widget.diaryModel.imgFile[0]),
                                  fit: BoxFit.cover)),
                        )
                ],
              )
            ],
          )),
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
      size: 18,
    );
    return selectedIcon;
  }

  Color checkMoodColor() {
    String moodData = widget.diaryModel.mood;
    return (moodData == 'joyful'
        ? MyAppTheme.moodJoyfulColor.withOpacity(0.3)
        : moodData == 'happy'
            ? MyAppTheme.moodHappyColor.withOpacity(0.3)
            : moodData == 'normal'
                ? MyAppTheme.moodNormalColor.withOpacity(0.3)
                : moodData == 'sad'
                    ? MyAppTheme.moodSadColor.withOpacity(0.3)
                    : moodData == 'angry'
                        ? MyAppTheme.moodAngryColor.withOpacity(0.3)
                        : const Color(0xff808080).withOpacity(0.3));
  }
}
