import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiOperations {
  String api = 'http://13.126.117.5/';

  Future<String> askOnyx({
    required String command,
    required BuildContext context,
  }) async {
    log('called the function');
    final url = Uri.parse(api);
    String reply = '';
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
        reply = data.toString().trim();
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