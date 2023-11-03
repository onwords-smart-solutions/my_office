import '../repository/auth_repository.dart';

class RemoveFcmCase {
  final AuthRepository authRepository;

  RemoveFcmCase({required this.authRepository});

  Future<void> execute({
    required String userId,
  }) async =>
      await authRepository.removeFcmToken(userId: userId);
}