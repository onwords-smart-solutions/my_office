import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';

import '../../domain/entity/create_lead_entity.dart';

abstract class CreateLeadFbDataSource {
  Future<Either<ErrorResponse, bool>> createCustomerLead(CreateLeadEntity createLeadEntity);
}

