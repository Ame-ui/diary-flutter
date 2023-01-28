import 'dart:io' as io;

import 'package:diary/provider/diary_content_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'my_app_theme.dart';

class DiaryContentWidget extends StatefulWidget {
  DiaryContentWidget({super.key, required this.widgetType, required this.index, this.file});
  final String widgetType;
  int index;
  final io.File? file;
  TextEditingController textController = TextEditingController();
  @override
  State<DiaryContentWidget> createState() => _DiaryContentWidgetState();
}

class _DiaryContentWidgetState extends State<DiaryContentWidget> {
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    // if (widget.widgetType == 'text') {
    //   widget.tc!.text = widget.index.toString();
    // }
    if (widget.widgetType == 'video') {
      _videoPlayerController = VideoPlayerController.file(widget.file!);
      _videoPlayerController.pause();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.widgetType) {
      case 'text':
        return contentTextField();
      case 'image':
        return contentImage();
      case 'video':
        return contentVideo();
      default:
        return const Center(
          child: Text('Error'),
        );
    }
  }

  Container contentTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: widget.textController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Text available here',
            hintStyle: TextStyle(color: MyAppTheme.disableColor)),
      ),
    );
  }

  Container contentImage() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Stack(alignment: const Alignment(1, -1), children: [
        Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: MyAppTheme.primaryTxtColor, width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(11),
              bottomLeft: Radius.circular(11),
              bottomRight: Radius.circular(11),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Image(
              image: FileImage(widget.file!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        InkWell(
          onTap: (() {
            var contentProvider = Provider.of<DiaryContentProvider>(context, listen: false);
            contentProvider.removeWidget(widget.index);
            //Fluttertoast.showToast(msg: 'remove');
          }),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.close,
              color: MyAppTheme.itemBgColor,
            ),
          ),
        )
      ]),
    );
  }

  Container contentVideo() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Stack(alignment: const Alignment(1, -1), children: [
        Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: MyAppTheme.primaryTxtColor, width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(11),
              bottomLeft: Radius.circular(11),
              bottomRight: Radius.circular(11),
            ),
          ),
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController)),
                  VideoProgressIndicator(
                    _videoPlayerController,
                    allowScrubbing: true,
                    padding: const EdgeInsets.only(bottom: 5),
                    colors: VideoProgressColors(
                        backgroundColor: MyAppTheme.disableColor,
                        playedColor: MyAppTheme.primaryColor),
                  ),
                  Container(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (() {
                              setState(() {
                                _videoPlayerController.seekTo(
                                    _videoPlayerController.value.position -
                                        const Duration(seconds: 5));
                              });
                            }),
                            child: Icon(Icons.fast_rewind, color: MyAppTheme.searchColor),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: (() {
                              setState(() {
                                _videoPlayerController.value.isPlaying
                                    ? _videoPlayerController.pause()
                                    : _videoPlayerController.play();
                              });
                            }),
                            child: Icon(
                              _videoPlayerController.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: MyAppTheme.searchColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: (() {
                              setState(() {
                                _videoPlayerController.seekTo(
                                    _videoPlayerController.value.position +
                                        const Duration(seconds: 5));
                              });
                            }),
                            child: Icon(Icons.fast_forward, color: MyAppTheme.searchColor),
                          ),
                        ],
                      )),
                ],
              )),
        ),
        InkWell(
          onTap: (() {
            var contentProvider = Provider.of<DiaryContentProvider>(context, listen: false);
            _videoPlayerController.pause();
            contentProvider.removeWidget(widget.index);

            //Fluttertoast.showToast(msg: 'remove');
          }),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.close,
              color: MyAppTheme.itemBgColor,
            ),
          ),
        )
      ]),
    );
  }

  Container contentAudio() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Stack(alignment: const Alignment(1, -1), children: [
        Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: MyAppTheme.primaryTxtColor, width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(11),
              bottomLeft: Radius.circular(11),
              bottomRight: Radius.circular(11),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Image(
              image: FileImage(widget.file!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        InkWell(
          onTap: (() {
            var contentProvider = Provider.of<DiaryContentProvider>(context, listen: false);
            contentProvider.removeWidget(widget.index);
          }),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.close,
              color: MyAppTheme.itemBgColor,
            ),
          ),
        )
      ]),
    );
  }
}
