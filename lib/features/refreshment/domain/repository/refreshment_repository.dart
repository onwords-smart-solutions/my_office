abstract class RefreshmentRepository {
  Future<Map<String, dynamic>> getRefreshmentDetails(
      {required String date, required String mode,});

  Future<Map<String, dynamic>> getFoodDetails({required String date});

  Future<Map<String, dynamic>> fetchRefreshmentDetails({
    required String date,
    required String mode,
  });

  Future<Map<String, dynamic>> fetchFoodDetails({required String date});

  Future<bool> orderItem({required String name, required String item, required String date, required String mode});

  Future<bool> bookLunch({required String name, required String date});
}
