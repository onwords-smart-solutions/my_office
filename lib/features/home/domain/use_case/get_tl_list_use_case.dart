import 'package:either_dart/either.dart';
import 'package:my_office/features/home/domain/repository/home_repository.dart';

import '../../../../core/utilities/response/error_response.dart';

class GetTlListCase{
  final HomeRepository homeRepository;

  GetTlListCase({required this.homeRepository});

  Future<Either<ErrorResponse ,List<String>>> execute() async =>
      await homeRepository.getTLList();
}