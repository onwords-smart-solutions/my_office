
import 'package:either_dart/either.dart';

import 'package:my_office/core/utilities/response/error_response.dart';
import '../repository/home_repository.dart';

class BirthdaySubmitFormCase {
  final HomeRepository homeRepository;

  BirthdaySubmitFormCase({required this.homeRepository});

  Future<Either<ErrorResponse, bool>> execute(context) async =>
      await homeRepository.birthdaySubmitForm(context);
}