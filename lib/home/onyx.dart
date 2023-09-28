import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/home/api_operations.dart';
import 'package:my_office/home/user_home_screen.dart';
import '../Constant/colors/constant_colors.dart';


final ValueNotifier<String> tapped = ValueNotifier('');

class Onyx extends StatelessWidget {
  final VoidCallback onListen;
  final VoidCallback onStop;

  // final void Function(String) onyxVoice;
  final TextEditingController _messageController = TextEditingController();

  // final ApiOperations _apiOperations = ApiOperations();
  final FlutterTts flutterTts = FlutterTts();

  String capitalizeFirstLetter(String text) {
    if (text.isNotEmpty) {
      return text[0].toUpperCase() +
          text.substring(1);
    }
    return text;
  }

  Onyx({
    super.key,
    required this.onListen,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Onyx AI Assistant',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
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
                      flutterTts.speak(replyFromOnyx.value['response']);
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
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: ValueListenableBuilder(
        valueListenable: replyFromOnyx,
        builder: (ctx, response, child) {
          return ValueListenableBuilder(
            valueListenable: recognizedWords,
            builder: (ctx, pickedWords, child) {
              return ValueListenableBuilder(
                valueListenable: isListening,
                builder: (ctx, isListen, child) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                  color: Color(0xff6F61C0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                     'You : ${capitalizeFirstLetter(pickedWords)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ValueListenableBuilder(
                                    valueListenable: replyFromOnyx,
                                    builder: (ctx, response, child) {
                                      return response.isNotEmpty
                                          ? ValueListenableBuilder(
                                        valueListenable: tapped,
                                        builder: (ctx, tap, child) {
                                              return Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () async {
                                                        tapped.value = 'like';
                                                       await ApiOperations().likeOnyx(
                                                          button: 'like',
                                                          context: context,
                                                        );
                                                      },
                                                      child: Icon(
                                                         tap == 'like' ? CupertinoIcons.hand_thumbsup_fill :CupertinoIcons.hand_thumbsup,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  const SizedBox(width: 10),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      tapped.value = 'dislike';
                                                      await ApiOperations().dislikeOnyx(
                                                        button: 'dislike',
                                                        context: context,
                                                      );
                                                    },
                                                    child:  Icon(
                                                     tap == 'dislike' ? CupertinoIcons.hand_thumbsdown_fill : CupertinoIcons.hand_thumbsdown,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          )
                                          : const SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ValueListenableBuilder(
                              valueListenable: replyFromOnyx,
                              builder: (ctx, response, child) {
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    color: response.isEmpty ? Colors.transparent :Colors.white,
                                  ),
                                  child:  ValueListenableBuilder(
                                    valueListenable: isLoading,
                                    builder: (ctx, loading, child) {
                                      return loading
                                          ? Center(
                                              child: Lottie.asset('assets/animations/onyx_loading.json',height: 80),
                                            )
                                          : Align(
                                        alignment: AlignmentDirectional.centerEnd,
                                            child: SelectableText(
                                                'Onyx : ${response['response']}',
                                                style: TextStyle(
                                                  color: response.isEmpty ? Colors.transparent :Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                          );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.sizeOf(context).height * .08,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: isListening,
                              builder: (ctx, isListen, child) {
                                return CircleAvatar(
                                  maxRadius: 25,
                                  child: IconButton(
                                    color: Colors.deepPurple,
                                      tooltip: 'Onyx',
                                      onPressed: onListen,
                                      icon: Icon(
                                        isListen ? Icons.mic : Icons.mic_off,
                                      ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            buildTextField(context),
                          ],
                        ),
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
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .7,
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
              callOnyx(context, recognizedWords.value);
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
            // height: 2,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.withOpacity(.7),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(width: 1.5, color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }
}

Future<void> callOnyx(BuildContext context, dynamic command) async {
  replyFromOnyx.value = {};
  tapped.value = '';
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
    await flutterTts.speak(result['response']);
    isLoading.value = false;
    replyFromOnyx.value = result;
  }
}
