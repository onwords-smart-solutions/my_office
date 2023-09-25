import 'package:flutter/material.dart';
import 'package:my_office/home/user_home_screen.dart';

class Onyx extends StatelessWidget {
  final VoidCallback onListen;
  final VoidCallback onStop;

  const Onyx({super.key, required this.onListen, required this.onStop});

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
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
                          return loading ? const Center(child: CircularProgressIndicator()) : SelectableText(
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
}
