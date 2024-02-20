import 'dart:io';

abstract class SearchLeadsRepository {
  Future<List<Map<Object?, Object?>>> getCustomers();

  Future<List<String>> getPRStaffNames();

  Future<void> updateCustomerLead(String phoneNumber, String staff);

  Stream<Map<Object?, Object?>> getCustomerDetails(String phoneNumber);

  Stream<dynamic> getCustomerNotes(String phoneNumber);

  Future<void> changeCustomerState(String phoneNumber, String state);

  Future<void> updateLead(String phoneNumber, String leadName);

  Future<void> addNoteToDatabase({
    required Map<Object?, Object?> customerInfo,
    required String currentStaffName,
    String? notes,
    String? reminder,
    File? audioFile,
    String? reminderDate,
  });

  Future<void> sendFeedback(Map<String, dynamic> body, String bearerToken, String customerWhatsAppNumber);

  Future<void> getBucketList();

  Future <void> updateBucketList(String mobile, String user,String oldUser);
}
