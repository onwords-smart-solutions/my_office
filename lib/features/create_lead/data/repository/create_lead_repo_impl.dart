
import 'package:either_dart/either.dart';
import 'package:my_office/features/create_lead/data/data_source/create_lead_fb_data_source.dart';
import 'package:my_office/features/create_lead/domain/entity/create_lead_entity.dart';
import 'package:my_office/features/create_lead/domain/repository/create_lead_repository.dart';

import '../../../../core/utilities/response/error_response.dart';

class CreateLeadRepoImpl implements CreateLeadRepository {
  final CreateLeadFbDataSource _createLeadFbDataSource;

  CreateLeadRepoImpl(this._createLeadFbDataSource);

  @override
  Future<Either<ErrorResponse, bool>> createCustomerLead(CreateLeadEntity createLeadEntity) async {
    return await _createLeadFbDataSource.createCustomerLead(createLeadEntity);
  }
}
