import 'dart:developer';

import 'package:my_office/features/refreshment/data/data_source/refreshment_fb_data_source.dart';
import 'package:my_office/features/refreshment/domain/repository/refreshment_repository.dart';

class RefreshmentRepoImpl implements RefreshmentRepository {
  final RefreshmentFbDataSource refreshmentFbDataSource;

  RefreshmentRepoImpl(this.refreshmentFbDataSource);

  @override
  Future<Map<String, dynamic>> getFoodDetails({required String date}) async {
    final snapshot = await refreshmentFbDataSource.getFoodData(date: date);
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return {};
  }

  @override
  Future<Map<String, dynamic>> getRefreshmentDetails({
    required String date,
    required String mode,
  }) async {
    final snapshot = await refreshmentFbDataSource.getRefreshmentData(
      date: date,
      mode: mode,
    );
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return {};
  }

  @override
  Future<bool> bookLunch({required String name, required String date}) async {
    try {
      final foodDetails = await fetchFoodDetails(date: date);
      int foodCount = 0;

      if (foodDetails.isNotEmpty) {
        foodCount = foodDetails['lunch_count'] ?? 0;
      }
      await refreshmentFbDataSource.updateFoodCount(
        date: date,
        name: name,
        foodCount: foodCount,
      );
      return true;
    } catch (e) {
      print('Error booking lunch: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchFoodDetails({required String date}) async {
    final snapshot = await refreshmentFbDataSource.getFoodDetails(date: date);
    return snapshot.exists
        ? Map<String, dynamic>.from(snapshot.value as Map)
        : {};
  }

  @override
  Future<Map<String, dynamic>> fetchRefreshmentDetails({
    required String date,
    required String mode,
  }) async {
    final snapshot = await refreshmentFbDataSource.getRefreshmentDetails(
      date: date,
      mode: mode,
    );
    return snapshot.exists
        ? Map<String, dynamic>.from(snapshot.value as Map)
        : {};
  }

  @override
  Future<bool> orderItem({
    required String name,
    required String item,
    required String date,
    required String mode,
  }) async {
    try {
      final refreshmentDetails =
          await fetchRefreshmentDetails(mode: mode, date: date);
      int itemCount = 0;

      if (refreshmentDetails.isNotEmpty) {
        itemCount = refreshmentDetails['${item.toLowerCase()}_count'] ?? 0;
      }
      await refreshmentFbDataSource.updateRefreshmentCount(
        name: name,
        date: date,
        mode: mode,
        item: item,
        count: itemCount,
      );
      return true;
    } catch (e) {
      print('Error ordering item: $e');
      return false;
    }
  }
}
