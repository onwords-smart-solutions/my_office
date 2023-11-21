import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:my_office/features/search_leads/data/data_source/search_leads_fb_data_source.dart';

class SearchLeadsFbDataSourceImpl implements SearchLeadsFbDataSource {
  final ref = FirebaseDatabase.instance.ref();
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Future<List<Map<Object?, Object?>>> getCustomers() async {
    DatabaseEvent customerEvent = await ref.child('customer').once();
    List<Map<Object?, Object?>> customers = [];
    for (var customer in customerEvent.snapshot.children) {
      final data = customer.value as Map<Object?, Object?>;
      customers.add(data);
    }
    return customers;
  }

  @override
  Future<List<String>> getPRStaffNames() async {
    DatabaseEvent staffEvent = await ref.child('staff').once();
    List<String> staffNames = ['All', 'Not Assigned'];
    for (var data in staffEvent.snapshot.children) {
      var fbData = data.value as Map<Object?, Object?>;
      if (fbData['department'] == 'PR') {
        final name = fbData['name'].toString();
        staffNames.add(name);
      }
    }
    return staffNames;
  }

  @override
  Future<void> updateCustomerLead(String phoneNumber, String staff) async {
    await ref.child('customer/$phoneNumber').update({'LeadIncharge': staff});
  }

  @override
  Stream<Map<Object?, Object?>> getCustomerDetails(String phoneNumber) {
    return
        ref
        .child('customer/$phoneNumber')
        .onValue
        .map((event) => event.snapshot.value as Map<Object?, Object?>);
  }

  @override
  Stream<dynamic> getCustomerNotes(String phoneNumber) {
    return ref
        .child('customer/$phoneNumber/notes')
        .onValue;
  }

  @override
  Future<void> updateCustomerState(String phoneNumber, String state) async {
    await ref.child('customer/$phoneNumber').update({'customer_state': state});
  }

  @override
  Future<void> updateLead(String phoneNumber, String leadName) async {
    await ref
        .child('customer/$phoneNumber')
        .update({'LeadIncharge': leadName});
  }

  @override
  Future<void> updateReminder(String path, Map<String, dynamic> data) async {
    await ref.child(path).update(data);
  }

  @override
  Future<String> uploadAudioFile(String path, File audioFile) async {
    final ref = storageRef.child(path);
    await ref.putFile(audioFile);
    return ref.getDownloadURL();
  }

  @override
  Future<void> updateNotes(String path, Map<String, dynamic> data) async {
    await ref.child(path).update(data);
  }

  @override
  Future<http.Response> postFeedback(Map<String, dynamic> body, String bearerToken, String customerWhatsAppNumber) async {
    var url = Uri.parse('https://live-server-116191.wati.io/api/v2/sendTemplateMessage?whatsappNumber=$customerWhatsAppNumber');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };

    final response = await http.post(url, headers: headers, body: json.encode(body));
    return response;
  }
}
