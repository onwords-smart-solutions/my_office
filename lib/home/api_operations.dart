import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_office/home/user_home_screen.dart';

class ApiOperations {
  String api = 'http://13.126.117.5/';

  //Post function for Onyx
  Future<dynamic> askOnyx({
    required String command,
    required BuildContext context,
  }) async {
    log('called the response api');
    final url = Uri.parse(api);
    dynamic reply = '';
    try {
      final response = await http
          .post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "command": command,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        reply = data;
      }
      log('REPLY IS $reply');
    } catch (e) {
      showErrorSnackbar(
        message: 'Something went wrong. Try again',
        context: context,
      );
    }
    return reply;
  }

  //Like function for Onyx
  Future<dynamic> likeOnyx({required String button, required BuildContext context}) async {
    String likeApi = 'http://13.126.117.5/like/${replyFromOnyx.value['data_id']}';
    log('like response is ${replyFromOnyx.value['data_id']}');
    final url = Uri.parse(likeApi);
    String likeButton = '';
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "likeButton": button,
        }),
      );
      log('called api ${response.body}');
    }catch(e){
      showErrorSnackbar(
        message: '$e',
        context: context,
      );
    }
    return likeButton;
  }

  //Dislike function for onyx
  Future<dynamic> dislikeOnyx({required String button, required BuildContext context}) async {
    String dislikeApi = 'http://13.126.117.5/dislike/${replyFromOnyx.value['data_id']}';
    log('dislike response is ${replyFromOnyx.value['data_id']}');
    final url = Uri.parse(dislikeApi);
    String dislikeButton = '';
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "dislikeButton": button,
        }),
      );
      log('called api ${response.body}');
    }catch(e){
      showErrorSnackbar(
        message: '$e',
        context: context,
      );
    }
    return dislikeButton;
  }

  //SNACK BAR
  void showErrorSnackbar({
    required String message,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}