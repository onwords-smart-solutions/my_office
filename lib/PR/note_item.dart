import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class NoteItem extends StatefulWidget {
  final String updatedStaff;
  final String updatedTime;
  final String updatedDate;
  final String note;
  final String url;
  final String reminder;

  const NoteItem({
    Key? key,
    required this.note,
    required this.updatedDate,
    required this.updatedStaff,
    required this.updatedTime,
    required this.url,
    required this.reminder
  }) : super(key: key);

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
   var firebaseRef  = FirebaseDatabase.instance.ref().child('customer/');

   final audioPlayer = AudioPlayer();
   bool isPlaying = false;
   bool isPaused = false;
   Duration duration = Duration.zero;
   Duration position = Duration.zero;


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
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 5.0)
          ],
          color: Colors.white),
      child: Column(
        children: [
          //heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Staff name
              Text(
                widget.updatedStaff,
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 13.0,
                ),
              ),

              //updated datetime
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.updatedDate,
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    widget.updatedTime,
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              )
            ],
          ),
          const Divider(height: 0.0),
          //body

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Text(
                  widget.note,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: ConstantFonts.poppinsRegular,
                    fontSize: 13.0,
                  ),
                ),
                  //Adding audio of calls
                  widget.url != 'null'
                      ? Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.play(
                                UrlSource(widget.url));
                          }
                        },
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          size: 45,
                          color: isPlaying ? Colors.red : Colors.green,),
                      ),
                      SizedBox(
                        width: width * 0.7,
                        child: SliderTheme(
                          data: const SliderThemeData(
                            trackHeight: 3,
                          ),
                          child: Slider(
                              activeColor: ConstantColor.backgroundColor,
                              inactiveColor: Colors.grey,
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              value: position.inSeconds.toDouble(),
                              onChanged: (value) async {
                                final position = Duration(seconds: value.toInt());
                                await audioPlayer.seek(position);
                              }),
                        ),
                      ),
                    ],
                  )
                      : const SizedBox.shrink(),
                //Adding reminder date
                const SizedBox(height: 10),
                widget.reminder != 'null'
                ? Text(
                    'Next Reminder - ${widget.reminder}',
                  style: TextStyle(
                    color: CupertinoColors.systemPurple,
                    fontWeight: FontWeight.w600,
                    fontFamily: ConstantFonts.poppinsRegular,
                    fontSize: 13.0,
                  ),
                ) :
                    const SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
