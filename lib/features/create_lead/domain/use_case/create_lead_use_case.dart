import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';

import '../entity/create_lead_entity.dart';
import '../repository/create_lead_repository.dart';

class CreateLeadCase{
  final CreateLeadRepository createLeadRepository;

  CreateLeadCase({required this.createLeadRepository});

  Future <Either<ErrorResponse, bool>> execute (CreateLeadEntity createLeadEntity)async {
    if (createLeadEntity.name.isEmpty) {
      throw Exception('Enter the customer name');
    } else if (createLeadEntity.phoneNumber.isEmpty) {
      throw Exception('Enter a valid phoneNumber');
    } else if (createLeadEntity.emailId.isEmpty) {
      throw Exception('Enter a valid Email id');
    } else if (createLeadEntity.city.isEmpty) {
      throw Exception('Enter a city name');
    }else if (createLeadEntity.inquiredFor.isEmpty) {
      throw Exception('Enter a valid name of enquiry');
    }else if (createLeadEntity.dataFetchedBy.isEmpty) {
      throw Exception('Enter a data fetched details');
    }
   return await createLeadRepository.createCustomerLead(createLeadEntity);
  }
}