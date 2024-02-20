import 'dart:io';

import 'package:http/http.dart' as http;

abstract class SearchLeadsFbDataSource {
  Future<List<Map<Object?, Object?>>> getCustomers();

  Future<List<String>> getPRStaffNames();

  Future<void> updateCustomerLead(String phoneNumber, String staff);

  Stream<Map<Object?, Object?>> getCustomerDetails(String phoneNumber);

  Stream<dynamic> getCustomerNotes(String phoneNumber);

  Future<void> updateCustomerState(String phoneNumber, String state);

  Future<void> updateLead(String phoneNumber, String leadName);

  Future<void> updateReminder(String path, Map<String, dynamic> data);

  Future<String> uploadAudioFile(String path, File audioFile);

  Future<void> updateNotes(String path, Map<String, dynamic> data);

  Future<http.Response> postFeedback(Map<String, dynamic> body,
      String bearerToken, String customerWhatsAppNumber);

  Future<void> getBucketList();

  Future <void> updateBucketList(String mobile, String user, String oldUser);
}

