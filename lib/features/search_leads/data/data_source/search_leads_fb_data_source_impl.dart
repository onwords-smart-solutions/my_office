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
  Future<void> getBucketList() async {
    ref.child('Bucket').once().then((value) {
      if (value.snapshot.exists) {
        for (var user in value.snapshot.children) {
          for (var bucket in user.children) {
            final bucketData = bucket.value as Map<Object?, Object?>;
            log('Bucket data is $bucketData');
          }
        }
      }
    });
  }

  @override
  Future <void> updateBucketList(String mobile, String user, String oldUser) async {
    var bucketName = await _determineBucketName(user);
    log('Bucket name is $bucketName');
    try{
      final size = '${bucketName.values.first+1}'.padLeft(2, '0');
      await ref
          .child('Bucket/$user/${bucketName.keys.first}/$size')
          .set(mobile);
      await ref
          .child('Bucket/$user/Counter')
          .update({bucketName.keys.first:int.parse(size)});
    }catch(e){
      print('Error caught in Updating data in bucket $e');
    }
  }

  Future<Map<String, int>> _determineBucketName(String user) async {
    String bucketName = '';
    int currentBucketSize = 0;
    final counterSnapshot = await ref.child('Bucket/$user').get();
    if(counterSnapshot.exists){
      int counter = 0;
      for(final field in counterSnapshot.children){
        if(field.key.toString().toLowerCase().contains('bucket')){
         final value = field.value as Map<Object?, Object?>;
         final key = value.keys.toList();
         key.sort();
         if(int.parse(key.last.toString())<50){
           currentBucketSize = int.parse(key.last.toString());
           bucketName = field.key.toString();
           break;
         }else{
           counter += 1;
         }
        }
      }
     if(counter > 0 && bucketName.isEmpty){
       final num ='${counter+1}';
       bucketName = 'Bucket${num.padLeft(2,'0')}';
     } else if(bucketName.isEmpty){
       bucketName = 'Bucket01';
     }
    }
    return {bucketName:currentBucketSize};
  }
}
