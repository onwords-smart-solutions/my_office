import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class AddNotes extends StatefulWidget {
  final Map<Object?, Object?> customerInfo;
  final String currentStaffName;

  const AddNotes(
      {Key? key, required this.customerInfo, required this.currentStaffName})
      : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController notesController = TextEditingController();
  File? audioFile;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Future<void> picksinglefile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.audio, allowCompression: true);
    if (result != null) {
      if (!mounted) return;
      setState(() {
        audioFile = File(result.files.single.path.toString());
      });
    }
  }

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
    return Scaffold(
      backgroundColor: const Color(0xffF1F2F8),
      appBar: AppBar(
        title: Text(
          'Notes and Audio',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: ConstantFonts.poppinsRegular),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                Color(0xffD136D4),
                Color(0xff7652B2),
              ],
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Add notes :",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: ConstantFonts.poppinsRegular,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: notesController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: ConstantFonts.poppinsRegular,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Enter your notes here..',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                    fontFamily: ConstantFonts.poppinsRegular,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: picksinglefile,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Pick audio file',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: ConstantFonts.poppinsRegular,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height * 0.1,
                width: width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: audioFile != null
                    ? Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.play(
                              DeviceFileSource(audioFile!.path));
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
              ),
            ),
            SizedBox(height: height * 0.02),
            Center(
              child: Container(
                width: width * 0.6,
                height: height * 0.08,
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    addNoteToDatabase();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xff8355B7),
                    // fixedSize: Size(250, 50),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily: ConstantFonts.poppinsRegular,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addNoteToDatabase() async {
    if (notesController.text
        .trim()
        .isEmpty) {
      final snackBar = SnackBar(
        content: Text(
          'Enter some notes..',
          style: TextStyle(
            fontFamily: ConstantFonts.poppinsRegular,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // print('no data');
    } else if (audioFile != null) {
      DateTime now = DateTime.now();
      var timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);
      final audio = FirebaseStorage.instance.ref().child(
          'AUDIO_NOTES/${widget.customerInfo['phone_number']
              .toString()}/${DateTime
              .now()
              .millisecondsSinceEpoch}/${widget.currentStaffName}');
      audio.putFile(File(audioFile!.absolute.path)).whenComplete(() async {
        final url = await audio.getDownloadURL();

        final ref = FirebaseDatabase.instance.ref();
        ref.child(
            'customer/${widget.customerInfo['phone_number']
                .toString()}/notes/$timeStamp')
            .update(
          {
            'date': DateFormat('yyyy-MM-dd').format(now),
            'entered_by': widget.currentStaffName,
            'note': notesController.text.trim(),
            'time': DateFormat('kk:mm').format(now),
            'audio_file': url,
          },
        );
        notesController.clear();
      });
      final snackBar = SnackBar(
        content: Text(
          'Your data has been saved..',
          style: TextStyle(
            fontFamily: ConstantFonts.poppinsRegular,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      DateTime now = DateTime.now();
      var timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);
      final ref = FirebaseDatabase.instance.ref();
      ref.child(
          'customer/${widget.customerInfo['phone_number']
              .toString()}/notes/$timeStamp')
          .update(
        {
          'date': DateFormat('yyyy-MM-dd').format(now),
          'entered_by': widget.currentStaffName,
          'note': notesController.text.trim(),
          'time': DateFormat('kk:mm').format(now),
        },
      );
      notesController.clear();
      final snackBar = SnackBar(
        content: Text(
          'Your data has been saved..',
          style: TextStyle(
            fontFamily: ConstantFonts.poppinsRegular,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
