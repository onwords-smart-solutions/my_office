
import 'package:firebase_database/firebase_database.dart';

import 'food_count_fb_data_source.dart';

class FoodCountFbDataSourceImpl implements FoodCountFbDataSource {
  final DatabaseReference _ref;

  FoodCountFbDataSourceImpl(this._ref);

  @override
  Future<DataSnapshot> getStaff() async {
    DatabaseEvent event =  await _ref.child('staff').once();
    return event.snapshot;
  }

  @override
  Future<DataSnapshot> getRefreshments() async {
    DatabaseEvent event = await _ref.child('refreshments').once();
    return event.snapshot;
  }
}
