import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';

import '../../data/data_source/search_leads_fb_data_source.dart';
import '../../data/data_source/search_leads_fb_data_source_impl.dart';
import '../../data/repository/search_leads_repo_impl.dart';
import '../../domain/repository/search_leads_repository.dart';

class AddNotes extends StatefulWidget {
  final Map<Object?, Object?> customerInfo;
  final String currentStaffName;

  const AddNotes({
    Key? key,
    required this.customerInfo,
    required this.currentStaffName,
  }) : super(key: key);

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

  late SearchLeadsFbDataSource searchLeadsFbDataSource =
      SearchLeadsFbDataSourceImpl();
  late SearchLeadsRepository searchLeadsRepository =
      SearchLeadsRepoImpl(searchLeadsFbDataSource);

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF1F2F8),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          splashRadius: 20.0,
        ),
        centerTitle: true,
        title: const Text(
          'Notes and Audio',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Add notes ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
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
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
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
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: CupertinoColors.systemGrey,
                      width: 2,
                    ),
                  ),
                  hintText: 'Enter your notes here..',
                  hintStyle: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Set Reminder',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
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
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      dateController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  prefixIcon: const Icon(
                    CupertinoIcons.calendar,
                    color: CupertinoColors.systemPurple,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: CupertinoColors.systemPurple,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: CupertinoColors.systemGrey,
                      width: 2,
                    ),
                  ),
                  hintText: 'Tap to pick a date',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: FilledButton.tonal(
                onPressed: picksinglefile,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Pick audio file',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
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
              ),
            ),
            SizedBox(height: height * 0.02),
            Center(
              child: AppButton(
                onPressed: saveData,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveData() async {
    String notes = notesController.text.trim();
    String reminder = dateController.text.trim();

    if (notes.isEmpty && (reminder.isEmpty || audioFile == null)) {
      _showErrorSnackBar(
          'Please enter some notes, set a reminder, or add an audio file.',);
      return;
    }

    try {
      await searchLeadsRepository.addNoteToDatabase(
        customerInfo: widget.customerInfo,
        currentStaffName: widget.currentStaffName,
        notes: notes.isNotEmpty ? notes : null,
        reminder: reminder.isNotEmpty ? reminder : null,
        audioFile: audioFile,
      );
      String message = _buildSuccessMessage(notes, reminder, audioFile);
      _showSuccessSnackBar(message);
      notesController.clear();
      dateController.clear();
    } catch (e) {
      if(!mounted) return;
      _showErrorSnackBar('Error saving data: ${e.toString()}');
    }
  }

  String _buildSuccessMessage(String notes, String reminder, File? audioFile) {
    if (notes.isNotEmpty && reminder.isNotEmpty && audioFile != null) {
      return 'Notes, reminder, and audio saved successfully';
    } else if (audioFile != null && notes.isNotEmpty) {
      return 'Audio and notes saved successfully';
    } else if (reminder.isNotEmpty && notes.isNotEmpty) {
      return 'Reminder and notes saved successfully';
    } else if (notes.isNotEmpty) {
      return 'Notes saved successfully';
    }
    return 'Data saved successfully';
  }

  void _showSuccessSnackBar(String message) {
    CustomSnackBar.showSuccessSnackbar(
      message: message,
      context: context,
    );
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.showErrorSnackbar(
      message: message,
      context: context,
    );
  }
}
