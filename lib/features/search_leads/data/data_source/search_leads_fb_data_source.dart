import 'dart:io';

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
}

