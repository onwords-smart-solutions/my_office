import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/create_lead/domain/entity/create_lead_entity.dart';

abstract class CreateLeadRepository{
  Future<Either<ErrorResponse, bool>> createCustomerLead(CreateLeadEntity createLeadEntity);
}