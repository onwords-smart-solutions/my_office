import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/home/api_operations.dart';
import 'package:my_office/home/user_home_screen.dart';

import '../Constant/colors/constant_colors.dart';

class Onyx extends StatelessWidget {
  final VoidCallback onListen;
  final VoidCallback onStop;
  // final void Function(String) onyxVoice;
  final TextEditingController _messageController = TextEditingController();
  // final ApiOperations _apiOperations = ApiOperations();
  final FlutterTts flutterTts = FlutterTts();

  Onyx(
      {super.key,
      required this.onListen,
      required this.onStop,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Onyx AI Assistant',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: isPlayPause,
            builder: (ctx, isListen, child) {
              return CircleAvatar(
                child: IconButton(
                  color: ConstantColor.backgroundColor,
                  onPressed: () {
                    if (isListen) {
                      flutterTts.pause();
                      isPlayPause.value = false;
                    } else {
                      flutterTts.speak(replyFromOnyx.value);
                      isPlayPause.value = true;
                    }
                  },
                  icon: Icon(
                    isListen ? Icons.pause : Icons.play_arrow,
                  ),
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: 'Onyx',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            onPressed: onListen,
            child: ValueListenableBuilder(
              valueListenable: isListening,
              builder: (ctx, isListen, child) {
                return Icon(
                  isListen ? Icons.mic : Icons.mic_off,
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          buildTextField(context),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: replyFromOnyx,
        builder: (ctx, response, child) {
          return ValueListenableBuilder(
            valueListenable: recognizedWords,
            builder: (ctx, pickedWords, child) {
              return ValueListenableBuilder(
                valueListenable: isListening,
                builder: (ctx, isListen, child) {
                  return ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    children: [
                      SelectableText(
                        'Q: $pickedWords',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (ctx, loading, child) {
                          return loading
                              ? const Center(
                              child: CircularProgressIndicator(),)
                              : SelectableText(
                                  response,
                                );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: TextField(
        controller: _messageController,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.send,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        onSubmitted: (value) async {
          if (value.trim().isNotEmpty) {
            isLoading.value = true;
            recognizedWords.value = _messageController.text;
            try {
              _messageController.clear();
              callOnyx(context,recognizedWords.value);
            } catch (e, s) {
              print(s);
            }
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Type your queries',
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.withOpacity(.7),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(width: 1.5, color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }
}

Future<void> callOnyx(BuildContext context, String command) async {
  FlutterTts flutterTts = FlutterTts();
  final result = await ApiOperations().askOnyx(
    command: command.trim(),
    context: context,
  );
  if (result.isNotEmpty) {
    flutterTts.setCompletionHandler(() {
      isPlayPause.value = false;
      log('called text');
    });
    isPlayPause.value = true;
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setPitch(1.0); //0.5 to 2.0
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(result);

    isLoading.value = false;
    replyFromOnyx.value = result;
  }
}
