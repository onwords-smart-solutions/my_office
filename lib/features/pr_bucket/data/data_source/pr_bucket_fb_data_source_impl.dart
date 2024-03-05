import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/pr_bucket/data/data_source/pr_bucket_fb_data_source.dart';

class PrBucketFbDataSourceImpl extends PrBucketFbDataSource{
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<List<String>> getPrNames() async {
    DatabaseEvent staffEvent = await ref.child('Buckets').once();
    List<String> prNames = [];
    try{
      for (var data in staffEvent.snapshot.children) {
        final staffName = data.key;
        prNames.add(staffName!);
      }
    }catch(e){
      log('PR staff name error : $e');
    }
    return prNames;
  }

  @override
  Future <Map<String, List<Map<String, String>>>> getCustomerState(String prName) async{
    Map<String, List<Map<String, String>>> stateList = {};
    try{
      await ref.child('Buckets/$prName').once().then((value) {
        if(value.snapshot.exists) {
          for (final bucket in value.snapshot.children) {
            if (bucket.key.toString() != 'Counter') {
              List<Map<String, String>> customerList = [];
              for (final customer in bucket.children) {
                final phone = customer.key.toString();
                final state = customer
                    .child('state')
                    .value
                    .toString();
                customerList.add({phone: state});
              }
              stateList[bucket.key.toString()] = customerList;
            }
            List<String> sortedKeys = stateList.keys.toList()..sort(compareNumericStrings);
            Map<String, List<Map<String, String>>> sortedStateList = {};
            for (String key in sortedKeys) {
              sortedStateList[key] = stateList[key]!;
            }
            stateList = sortedStateList;
          }
        }
      });
    }catch(e){
      log('Customer state error : $e');
    }
    return stateList;
  }

  int compareNumericStrings(String a, String b) {
    int numA = int.tryParse(a.substring(6)) ?? 0;
    int numB = int.tryParse(b.substring(6)) ?? 0;
    return numA.compareTo(numB);
  }
}