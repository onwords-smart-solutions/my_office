import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
  TextEditingController dateController = TextEditingController();

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
                "Add notes ",
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: CupertinoColors.systemPurple,
                          width: 2)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: CupertinoColors.systemGrey, width: 2)
                  ),
                  hintText: 'Enter your notes here..',
                  hintStyle: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: ConstantFonts.poppinsRegular,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Set Reminder',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: ConstantFonts.poppinsRegular,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: dateController,
                textInputAction: TextInputAction.done,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                    DateFormat('yyyy-MM-dd')
                        .format(pickedDate);
                    setState(() {
                      dateController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  prefixIcon: const Icon(CupertinoIcons.calendar,
                      color: CupertinoColors.systemPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: CupertinoColors.systemPurple,
                          width: 2)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: CupertinoColors.systemGrey, width: 2)
                  ),
                  hintText: 'Tap to pick a date',
                  hintStyle: TextStyle(
                      fontFamily: ConstantFonts.poppinsRegular,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: CupertinoColors.systemGrey
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: ConstantFonts.poppinsRegular,
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
                          await audioPlayer
                              .play(DeviceFileSource(audioFile!.path));
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
                            activeColor: ConstantColor.backgroundColor,
                            inactiveColor: Colors.grey,
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              final position =
                              Duration(seconds: value.toInt());
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
    //CHECKING WHETHER NOTES IS EMPTY OR NOT
    if (notesController.text.trim().isEmpty) {
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
    }
    //CHECKING BOTH REMINDER AND AUDIO IS EMPTY OR NOT
    else if (dateController.text.trim().isNotEmpty && audioFile != null) {
      DateTime now = DateTime.now();
      var timeStamp = DateFormat('yyyy-MM-dd').format(now);
      final ref = FirebaseDatabase.instance.ref();
      await ref
          .child(
          'customer_reminders/$timeStamp/${widget
              .customerInfo['phone_number'].toString()}').
      update({
        'Customer_name': '${widget.customerInfo['name']}',
        'City': '${widget.customerInfo['city']}',
        'Customer_id': '${widget.customerInfo['customer_id']}',
        'Lead_in_charge': '${widget.customerInfo['LeadIncharge']}',
        'Created_by': '${widget.customerInfo['created_by']}',
        'Created_date': '${widget.customerInfo['created_date']}',
        'Created_time': '${widget.customerInfo['created_time']}',
        'State': '${widget.customerInfo['customer_state']}',
        'Data_fetched_by': '${widget.customerInfo['data_fetched_by']}',
        'Email_id': '${widget.customerInfo['email_id']}',
        'Enquired_for': '${widget.customerInfo['inquired_for']}',
        'Rating': '${widget.customerInfo['rating']}',
      }).then((value) {
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
          ref
              .child(
              'customer/${widget.customerInfo['phone_number']
                  .toString()}/notes/$timeStamp')
              .update({
            'date': DateFormat('yyyy-MM-dd').format(now),
            'entered_by': widget.currentStaffName,
            'note': notesController.text.trim(),
            'time': DateFormat('kk:mm').format(now),
            'audio_file': url,
          });
          notesController.clear();
          dateController.clear();
          final snackBar = SnackBar(
            content: Text(
              'Your audio file,reminder and notes has been saved..',
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
        });
      });
    }
    //CHECKING ONLY AUDIO FILE IS EMPTY OR NOT
    else if (audioFile != null) {
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
          ref
              .child(
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
          await audioPlayer.dispose();
          final snackBar = SnackBar(
            content: Text(
              'Your audio file and notes has been saved..',
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
        });
      }
    //CHECKING ONLY REMINDER IS EMPTY OR NOT
    else if (dateController.text.trim().isNotEmpty) {
        DateTime now = DateTime.now();
        var timeStamp = DateFormat('yyyy-MM-dd').format(DateTime.parse(dateController.text));
        final ref = FirebaseDatabase.instance.ref();
        ref
            .child(
            'customer_reminders/$timeStamp/${widget.customerInfo['phone_number']
                .toString()}').
        update({
          'Customer_name': '${widget.customerInfo['name']}',
          'City': '${widget.customerInfo['city']}',
          'Customer_id': '${widget.customerInfo['customer_id']}',
          'Lead_in_charge': '${widget.customerInfo['LeadIncharge']}',
          'Created_by': '${widget.customerInfo['created_by']}',
          'Created_date': '${widget.customerInfo['created_date']}',
          'Created_time': '${widget.customerInfo['created_time']}',
          'State': '${widget.customerInfo['customer_state']}',
          'Data_fetched_by': '${widget.customerInfo['data_fetched_by']}',
          'Email_id': '${widget.customerInfo['email_id']}',
          'Enquired_for': '${widget.customerInfo['inquired_for']}',
          'Rating': '${widget.customerInfo['rating']}',
          'Phone_number': '${widget.customerInfo['phone_number']}',
          'Updated_by': widget.currentStaffName.toString(),
        }).then((value) {
          DateTime now = DateTime.now();
          var timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);
          final ref = FirebaseDatabase.instance.ref();
          ref
              .child(
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
          dateController.clear();
          final snackBar = SnackBar(
            content: Text(
              'Your reminder and notes has been saved..',
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
        });
      }
    //ONLY IF NOTES IS NOT EMPTY
    else {
        DateTime now = DateTime.now();
        var timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);
        final ref = FirebaseDatabase.instance.ref();
        ref
            .child(
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
