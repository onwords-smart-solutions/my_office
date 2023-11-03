import '../repository/auth_repository.dart';

class GetFcmTokensCase {
  final AuthRepository authRepository;

  GetFcmTokensCase({required this.authRepository});

  Future<List<String>> execute({
    required String userId,
  }) async =>
      await authRepository.getFcmTokens(userId: userId);
}