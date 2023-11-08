import 'package:either_dart/either.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../repository/home_repository.dart';

class PhoneNumberSubmitFormCase {
  final HomeRepository homeRepository;

  PhoneNumberSubmitFormCase({required this.homeRepository});

  Future<Either<ErrorResponse, bool>> execute(context) async =>
      await homeRepository.phoneNumberSubmitForm(context);
}