import 'dart:io';

import 'package:intl/intl.dart';
import 'package:my_office/features/search_leads/data/data_source/search_leads_fb_data_source.dart';
import 'package:my_office/features/search_leads/domain/repository/search_leads_repository.dart';

class SearchLeadsRepoImpl implements SearchLeadsRepository {
  final SearchLeadsFbDataSource searchLeadsFbDataSource;

  SearchLeadsRepoImpl(this.searchLeadsFbDataSource);

  @override
  Future<List<Map<Object?, Object?>>> getCustomers() async {
    return await searchLeadsFbDataSource.getCustomers();
  }

  @override
  Future<List<String>> getPRStaffNames() async {
    return await searchLeadsFbDataSource.getPRStaffNames();
  }

  @override
  Future<void> updateCustomerLead(String phoneNumber, String staff) async {
    await searchLeadsFbDataSource.updateCustomerLead(phoneNumber, staff);
  }

  @override
  Stream<Map<Object?, Object?>> getCustomerDetails(String phoneNumber) {
    return searchLeadsFbDataSource.getCustomerDetails(phoneNumber);
  }

  @override
  Stream<dynamic> getCustomerNotes(String phoneNumber) {
    return searchLeadsFbDataSource.getCustomerNotes(phoneNumber);
  }

  @override
  Future<void> changeCustomerState(String phoneNumber, String state) {
    return searchLeadsFbDataSource.updateCustomerState(phoneNumber, state);
  }

  @override
  Future<void> updateLead(String phoneNumber, String leadName) async {
    await searchLeadsFbDataSource.updateLead(phoneNumber, leadName);
  }

  @override
  Future<void> addNoteToDatabase({
    required Map<Object?, Object?> customerInfo,
    required String currentStaffName,
    String? notes,
    String? reminder,
    File? audioFile,
  }) async {
    DateTime now = DateTime.now();
    String timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);
    String dateStamp = DateFormat('yyyy-MM-dd').format(now);

    // Handling reminders and audio files
    if (reminder != null && reminder.isNotEmpty && audioFile != null) {
      await _updateReminder(
        customerInfo,
        currentStaffName,
        reminder,
        dateStamp,
      );
      await _uploadAudioAndSaveNote(
        customerInfo,
        currentStaffName,
        notes,
        audioFile,
        timeStamp,
        reminder,
      );
    }
    // Handling only audio file
    else if (audioFile != null) {
      await _uploadAudioAndSaveNote(
        customerInfo,
        currentStaffName,
        notes,
        audioFile,
        timeStamp,
      );
    }
    // Handling only reminder
    else if (reminder != null && reminder.isNotEmpty) {
      await _updateReminder(
        customerInfo,
        currentStaffName,
        reminder,
        dateStamp,
      );
      await _saveNoteOnly(
        customerInfo,
        currentStaffName,
        notes,
        timeStamp,
        reminder,
      );
    }
    // Handling only notes
    else {
      await _saveNoteOnly(customerInfo, currentStaffName, notes, timeStamp);
    }
  }

  Future<void> _updateReminder(
    Map<Object?, Object?> customerInfo,
    String currentStaffName,
    String reminder,
    String dateStamp,
  ) async {
    String reminderPath =
        'customer_reminders/$dateStamp/${customerInfo['phone_number']}';
    Map<String, dynamic> reminderData = {
      'Customer_name': customerInfo['name'],
      'City': customerInfo['city'],
      'Customer_id': customerInfo['customer_id'],
      'Lead_in_charge': customerInfo['LeadIncharge'],
      'Created_by': customerInfo['created_by'],
      'Created_date': customerInfo['created_date'],
      'Created_time': customerInfo['created_time'],
      'State': customerInfo['customer_state'],
      'Data_fetched_by': customerInfo['data_fetched_by'],
      'Email_id': customerInfo['email_id'],
      'Enquired_for': customerInfo['inquired_for'],
      'Rating': customerInfo['rating'],
      'Phone_number': customerInfo['phone_number'],
      'Updated_by': currentStaffName,
    };
    await searchLeadsFbDataSource.updateReminder(reminderPath, reminderData);
  }

  Future<void> _uploadAudioAndSaveNote(
    Map<Object?, Object?> customerInfo,
    String currentStaffName,
    String? notes,
    File audioFile,
    String timeStamp, [
    String? reminder,
  ]) async {
    String audioPath =
        'AUDIO_NOTES/${customerInfo['phone_number']}/${DateTime.now().millisecondsSinceEpoch}/$currentStaffName';
    String audioUrl =
        await searchLeadsFbDataSource.uploadAudioFile(audioPath, audioFile);
    await _saveNote(
      customerInfo,
      currentStaffName,
      notes,
      timeStamp,
      audioUrl,
      reminder,
    );
  }

  Future<void> _saveNoteOnly(
    Map<Object?, Object?> customerInfo,
    String currentStaffName,
    String? notes,
    String timeStamp, [
    String? reminder,
  ]) async {
    await _saveNote(
      customerInfo,
      currentStaffName,
      notes,
      timeStamp,
      null,
      reminder,
    );
  }

  Future<void> _saveNote(
    Map<Object?, Object?> customerInfo,
    String currentStaffName,
    String? notes,
    String timeStamp,
    String? audioUrl, [
    String? reminder,
  ]) async {
    DateTime now = DateTime.now();
    String notePath =
        'customer/${customerInfo['phone_number']}/notes/$timeStamp';
    Map<String, dynamic> noteData = {
      'date': DateFormat('yyyy-MM-dd').format(now),
      'entered_by': currentStaffName,
      'note': notes ?? '',
      'time': DateFormat('kk:mm').format(now),
    };
    if (audioUrl != null) {
      noteData['audio_file'] = audioUrl;
    }
    if (reminder != null) {
      noteData['reminder'] = reminder;
    }
    await searchLeadsFbDataSource.updateNotes(notePath, noteData);
  }

  @override
  Future<void> sendFeedback(Map<String, dynamic> body, String bearerToken, String customerWhatsAppNumber) async {
    final response = await searchLeadsFbDataSource.postFeedback(body, bearerToken, customerWhatsAppNumber);

    if (response.statusCode != 200) {
      throw Exception('Failed to send feedback. Status code: ${response.statusCode}');
    }
  }
}
