import 'package:my_office/features/auth/domain/repository/auth_repository.dart';

class GetDeviceInfoCase{
  final AuthRepository authRepository;

  GetDeviceInfoCase({required this.authRepository});

  Future<String> execute() async => await authRepository.getDeviceInfo();
}