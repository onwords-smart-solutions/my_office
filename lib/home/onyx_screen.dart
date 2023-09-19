import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'api_operations.dart';

class OnyxScreen extends StatefulWidget {
  const OnyxScreen({Key? key}) : super(key: key);

  @override
  State<OnyxScreen> createState() => _OnyxScreenState();
}

class _OnyxScreenState extends State<OnyxScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ApiOperations _apiOperations = ApiOperations();
  final SpeechToText _speechToText = SpeechToText();
  bool _isFirst = true;
  bool _isListening = false;
  String _recognizedWords = '';
  String _reply = '';
  bool isCalled = false;

  void _initSpeech(BuildContext context) async {
    log('called');
    await _speechToText.initialize(onStatus: (value) async {
      if (value == 'listening') {
        if(mounted){
          setState(() {
            _recognizedWords = '';
            _isListening = true;
            _isFirst = false;
            _reply = '';
          });
        }
      } else {
        if(mounted){
          setState(() {
            _isListening = false;
          });
        }
        if(mounted){
          if (_recognizedWords.isNotEmpty && value == 'done') {
            final result = await _apiOperations.askOnyx(
              command: _recognizedWords.trim(), context: this.context,);
            if (result.toString().isNotEmpty) {
              setState(() {
                _reply = result.toString().trim();
              });
            }
          }
        }
      }
    },);
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {

    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {

    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _recognizedWords = result.recognizedWords;
    });
  }

  @override
  void initState() {
    final context = this.context;
    _initSpeech(context);
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _speechToText.cancel();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Onyx Speech'),
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            buildTextBody(),
            Positioned(bottom: 140.0, child: buildMicButton()),
            buildTextField(),
          ],
        ),);
  }

  Widget buildMicButton() {
    return ElevatedButton(

        onPressed: () {
          _isListening ? _stopListening() : _startListening();
        },
        style: IconButton.styleFrom(

            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(100.0),),
            padding: const EdgeInsets.all(20.0),),
        child: Icon(
          _isListening ? Icons.stop_rounded : Icons.mic,
          size: 30.0,
        ),
    );
  }

  Widget buildTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: TextField(
        controller: _messageController,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.send,
        onSubmitted: (value) async {
          if (value.trim().isNotEmpty) {
            setState(() {
              _reply = '';
              _isFirst = false;
              _recognizedWords = value.trim();
            });
            _messageController.clear();
            final result = await _apiOperations.askOnyx(
                command: value.trim(), context: context,);
            if (result.isNotEmpty) {
              setState(() {
                _reply = result.trim();
              });
            }
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Type here',
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

  Widget buildTextBody() {
    return _reply.isEmpty
        ? Center(
      child: _isListening
          ? const Text('Listening....',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.deepPurple,),)
          : _isFirst
          ? const Text('Tap mic to speak or Type your query',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.grey,),)
          : _recognizedWords.isEmpty
          ? const Text('Couldn\'t capture any words. Try again!',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black,),)
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_recognizedWords,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.deepPurple,),),
          const SizedBox(height: 20.0),
          LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.deepPurple, size: 50.0,),
        ],
      ),
    )
        : SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(
              'Q: $_recognizedWords'.toUpperCase(),
              style: const TextStyle(fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.bold,),
            ),
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 10.0, left: 10.0, right: 10.0,),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SelectableText(
                    _reply,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,),
                  ),
                ),),
          ),
        ],
      ),
    );
  }
}