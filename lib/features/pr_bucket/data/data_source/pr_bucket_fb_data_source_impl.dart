import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/pr_bucket/data/data_source/pr_bucket_fb_data_source.dart';

class PrBucketFbDataSourceImpl extends PrBucketFbDataSource{
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<List<String>> getPrNames() async {
    DatabaseEvent staffEvent = await ref.child('Bucket').once();
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
  Future<List<dynamic>> prBucketNames(String staff) async {
    DatabaseEvent ref = await FirebaseDatabase.instance.ref().child('Bucket').once();
    final bucketNames = [];
    try{
      for(var key in ref.snapshot.children){

        //to get PR staff names
        final staffName = key.key;
        for(var bucketId in key.children){
          if(staffName!.contains(staff)){
            final buckets = bucketId.key;
            if(buckets != 'Counter'){
              bucketNames.add(buckets);
            }
          }

          //sorting names alphabetically and numerically
          bucketNames.sort((a, b) {
            int numA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            int numB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            String nonNumA = a.replaceAll(RegExp(r'[0-9]'), '');
            String nonNumB = b.replaceAll(RegExp(r'[0-9]'), '');
            int compareNonNumeric = nonNumA.compareTo(nonNumB);
            if (compareNonNumeric != 0) {
              return compareNonNumeric;
            }
            return numA - numB;
          });
        }
      }

      //mapping bucket names with count
      DatabaseEvent counterRef = await FirebaseDatabase.instance.ref('Bucket/$staff').child('Counter').once();
      Map<Object?, Object?> counterData = counterRef.snapshot.value as Map<Object?, Object?> ?? {};
      for (int i = 0; i < bucketNames.length; i++) {
        String bucketName = bucketNames[i];
        final count = counterData[bucketName] ?? 0;
        bucketNames[i] = '$bucketName   -   $count';
      }

    }catch(error){
      log('PR bucket name error : $error');
    }
    return bucketNames;
  }

  @override
  Future<List<dynamic>> bucketValues(String prName, String bucketName) async {
    DatabaseEvent bucketRef = await ref.child('Bucket').once();
    List<dynamic> bucketData = [];
      try{
        if(bucketRef.snapshot.exists){
          for(var key in bucketRef.snapshot.children){

            //to get PR staff names
            final staffName = key.key;
            for(var value in key.children){
              if(staffName!.contains(prName)){

                //to get PR bucket names
                final buckets = value.key;
                for(var bucketValues in value.children){
                  if(buckets!.contains(bucketName.trim())){
                    final dataKey = bucketValues.key;
                        bucketData.add(dataKey);
                  }
                }
              }
            }
            bucketData.sort((a,b) => a.compareTo(b));
          }
        }
      }catch(e){
        log('PR bucket values error : $e');
      }
    return bucketData;
  }

  @override
  Future<List<dynamic>> getCustomerData(dynamic mobile)async {
    final List<dynamic> customerData = [];
    DatabaseEvent customerDb = await ref.child('customer').once();
    try{
      if(customerDb.snapshot.exists){
        for(var customer in customerDb.snapshot.children){
          for(var number in mobile){
            if(customer.key!.contains(number.trim())){
              final allCustomerData = customer.value as Map<Object?, Object?>;
              if(allCustomerData.containsKey('customer_state')){
                customerData.add(allCustomerData);
              }
            }
          }
        }
      }
    }catch(e){
      log('Customer data error : $e');
    }
    return customerData;
  }

  @override
  Future<List<dynamic>> getCustomerState(String prName, String bucketName) async{
    DatabaseEvent custState = await ref.child('Bucket').once();
    List<dynamic> state = [];
    try{
      if(custState.snapshot.exists){
        for(var key in custState.snapshot.children){
          //to get PR staff names
          final staffName = key.key;
          for(var value in key.children){
            if(staffName!.contains(prName)){

              //to get PR bucket names
              final buckets = value.key;
              for(var bucketValues in value.children){
                if(buckets!.contains(bucketName.trim())){
                  final stateValue = bucketValues.value as Map<Object?, Object?>;
                  final value = stateValue.values.first;
                  log('State values are $value');
                  state.add(value);
                }
              }
            }
          }
        }
      }
    }catch(e){
      log('Customer state error : $e');
    }
    return state;
  }
}