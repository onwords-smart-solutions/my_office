import '../repository/auth_repository.dart';

class StoreFcmCase {
  final AuthRepository authRepository;

  StoreFcmCase({required this.authRepository});

  Future<void> execute({
    required String userId,
  }) async =>
      await authRepository.storeFcmToken(userId: userId);
}