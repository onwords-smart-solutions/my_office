import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/refreshment/data/data_source/refreshment_fb_data_source.dart';

class RefreshmentFbDataSourceImpl implements RefreshmentFbDataSource{
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<DataSnapshot> getFoodData({required String date}) async{
    return await ref.child('refreshments/$date/Lunch').get();
  }

  @override
  Future<DataSnapshot> getRefreshmentData({required String date, required String mode})async {
    return await ref.child('refreshments/$date/$mode').get();
  }

  @override
  Future<DataSnapshot> getFoodDetails({required String date}) async{
    return await ref.child('/refreshments/$date/Lunch').get();
  }

  @override
  Future<DataSnapshot> getRefreshmentDetails({required String date, required String mode}) async{
    return await ref.child('/refreshments/$date/$mode').get();
  }

  @override
  Future<void> updateFoodCount(
      {required String name, required String date, required int foodCount}) async {
    await ref.child('/refreshments/$date/Lunch/lunch_list').update({
      'name${foodCount + 1}': name,
    });

    await ref.child('/refreshments/$date/Lunch').update({
      'lunch_count': foodCount + 1,
    });
  }

  @override
  Future<void> updateRefreshmentCount(
      {required String name, required String date, required String mode, required String item, required int count}) async{
    await ref.child('/refreshments/$date/$mode/${item.toLowerCase()}').update({
      'name${count + 1}': name,
    });

    await ref.child('/refreshments/$date/$mode').update({
      '${item.toLowerCase()}_count': count + 1,
    });
  }


}