import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/create_lead/domain/entity/create_lead_entity.dart';
import 'package:my_office/features/create_lead/domain/use_case/create_lead_use_case.dart';

class CreateLeadProvider extends ChangeNotifier{
  final CreateLeadCase createLeadCase;

  CreateLeadProvider(this.createLeadCase);

  Future<Either<ErrorResponse, bool>> createLead(CreateLeadEntity createLeadEntity) async{
    try{
      return await createLeadCase.execute(createLeadEntity);
    }catch(e){
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered while creating new lead.',
          error: 'Error caught while creating new lead $e',
        ),
      );
    }
  }
}