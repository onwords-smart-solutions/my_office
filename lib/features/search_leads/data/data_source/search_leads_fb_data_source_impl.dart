import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:my_office/features/search_leads/data/data_source/search_leads_fb_data_source.dart';

class SearchLeadsFbDataSourceImpl implements SearchLeadsFbDataSource {
  final ref = FirebaseDatabase.instance.ref();
  final storageRef = FirebaseStorage.instance.ref();
  static const int bucketSize = 50;

  @override
  Future<List<Map<Object?, Object?>>> getCustomers() async {
    DatabaseEvent customerEvent = await ref.child('customer').once();
    List<Map<Object?, Object?>> customers = [];
    for (var customer in customerEvent.snapshot.children) {
      try {
        final data = customer.value as Map<Object?, Object?>;
        customers.add(data);
      } catch (e) {
        log('Exception caught in Customer leads $e');
      }
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
  Future<http.Response> postFeedback(Map<String, dynamic> body,
      String bearerToken, String customerWhatsAppNumber,) async {
    var url = Uri.parse(
      'https://live-server-116191.wati.io/api/v2/sendTemplateMessage?whatsappNumber=$customerWhatsAppNumber',);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };

    final response = await http.post(
      url, headers: headers, body: json.encode(body),);
    return response;
  }

  @override
  Future <void> updateBucketList({required String mobile, required String user, required String oldUser, required String state}) async {
    String oldBucketName = await _determineOldBucketName(mobile, oldUser);

    if (oldBucketName.isNotEmpty) {
      await removeDataAndUpdateCounter(oldBucketName, oldUser, mobile);
    }
    try{
      final bucketName = await _determineBucketName(user);
      await _addDataToNewBucket(bucketName, mobile, user, state);
    }catch(e){
      print('Error caught in Updating data in bucket $e');
    }
  }


  Future<String> _determineBucketName(String user) async {
    final counterSnapshot = await ref.child('Buckets/$user').get();
    int lastUsedNumber = 0;
    if (counterSnapshot.exists) {
      for (final field in counterSnapshot.children) {
        if (field.key.toString().toLowerCase().contains('bucket')) {
          final bucketData = field.value as Map;
          if (bucketData.length < 50) {
            return field.key.toString();
          }
          final bucketNumber = int.tryParse(field.key.toString().substring('Bucket'.length));
          if (bucketNumber != null && bucketNumber > lastUsedNumber) {
            lastUsedNumber = bucketNumber;
          }
        }
      }
      final nextBucketNumber = lastUsedNumber + 1;
      return 'Bucket$nextBucketNumber';
    }
    return 'Bucket1';
  }

  Future<String> _determineOldBucketName(String mobile, String oldUser) async {
    final bucketSnapshot = await ref.child('Buckets/$oldUser').get();
    if (bucketSnapshot.exists) {
      for (final bucketChild in bucketSnapshot.children) { // Iterate over buckets
        final bucketData = bucketChild.value as Map;

        if (bucketData.containsKey(mobile)) {
          print('Old bucket name determined: ${bucketChild.key}');
          return bucketChild.key ?? '';
        }
      }
    }
    return '';
  }


  Future<void> _addDataToNewBucket(String bucketName, String mobile, String user, String state) async {
    // Assuming you want to preserve the 'state'
    final newDataRef = ref.child('Buckets/$user/$bucketName/$mobile');
    await newDataRef.set({'state': state});

    // Update Counter
    final counterPath = 'Buckets/$user/Counter/$bucketName';
    final counterSnapshot = await ref.child(counterPath).get();
    if (counterSnapshot.exists) {
      final currentCount = counterSnapshot.value as int? ?? 0;
      await ref.child(counterPath).set(currentCount + 1);
    } else {
      await ref.child(counterPath).set(1);
    }
  }

  Future<void> removeDataAndUpdateCounter(String oldBucketName, String oldUser, String mobile) async {
    // 1. Find and Remove Mobile Number
    final oldDataRef = ref.child('Buckets/$oldUser/$oldBucketName/$mobile');
    oldDataRef.remove();

      // 3. Update Counter
      final counterPath = 'Buckets/$oldUser/Counter/$oldBucketName';
      final counterSnapshot = await ref.child(counterPath).get();

      if (counterSnapshot.exists) {
        final currentCount = counterSnapshot.value as int;
        if(currentCount == 1){
          await ref.child(counterPath).remove();
        }else{
          await ref.child(counterPath).set(currentCount - 1);
        }
      }
  }

  @override
  Future<void> updateState({
    required String mobile,
    required String user,
    required String newState,
  }) async {
    final bucketsSnapshot = await ref.child('Buckets/$user').get();
    if (bucketsSnapshot.exists) {
      for (final bucketChild in bucketsSnapshot.children) {
        final bucketData = bucketChild.value as Map;
        if (bucketData.containsKey(mobile)) {
          final mobileRef = ref.child('Buckets/$user/${bucketChild.key}/$mobile');
          await mobileRef.update({'state': newState});
          return;
        }
      }
    }
    print('Mobile number not found in any bucket for user $user');
  }
}

