import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';

class NoteItem extends StatefulWidget {
  final String updatedStaff;
  final String updatedTime;
  final String updatedDate;
  final String note;
  final String url;

  const NoteItem({
    Key? key,
    required this.note,
    required this.updatedDate,
    required this.updatedStaff,
    required this.updatedTime,
    required this.url,
  }) : super(key: key);

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isAudio = false;

  @override
  void initState() {
    //Listen to player state change
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        if (!mounted) return;
        setState(() {
          position = Duration.zero;
        });
      }
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    //Listen to audio duration change
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;
      setState(() {
        duration = newDuration;
      });
    });

    //Listen to audio position change
    audioPlayer.onPositionChanged.listen((newPosition) {
      if (!mounted) return;
      setState(() {
        position = newPosition;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 5.0),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          //heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Staff name
              Text(
                widget.updatedStaff,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),

              //updated datetime
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.updatedDate,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    widget.updatedTime,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 0.0),
          //body

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                SelectableText(
                  widget.note,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                //Adding audio of calls
                widget.url != 'null'
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (isPlaying) {
                                audioPlayer.pause();
                              } else {
                                log('PLAYING PATH IS ${widget.url}');
                                isAudio
                                    ? audioPlayer.play(
                                        UrlSource(widget.url),
                                      )
                                    : audioPlayer.play(
                                        DeviceFileSource(widget.url),
                                      );
                              }
                            },
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              size: 45,
                              color: isPlaying ? Colors.red : Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.7,
                            child: SliderTheme(
                              data: const SliderThemeData(
                                trackHeight: 3,
                              ),
                              child: Slider(
                                activeColor: AppColor.primaryColor,
                                inactiveColor: Colors.grey,
                                min: 0,
                                max: duration.inSeconds.toDouble(),
                                value: position.inSeconds.toDouble(),
                                onChanged: (value) async {
                                  final position =
                                      Duration(seconds: value.toInt());
                                  await audioPlayer.seek(position);
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
