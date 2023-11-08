import 'package:either_dart/src/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/create_lead/data/data_source/create_lead_fb_data_source.dart';
import 'package:my_office/features/create_lead/domain/entity/create_lead_entity.dart';

class CreateLeadFbDataSourceImpl implements CreateLeadFbDataSource{

  final customerRef = FirebaseDatabase.instance.ref();

  @override
  Future<Either<ErrorResponse, bool>> createCustomerLead(CreateLeadEntity createLeadEntity) async {
    try{
      final customerData = {
        'name': createLeadEntity.name,
        'phone_number': createLeadEntity.phoneNumber,
        'email_id': createLeadEntity.emailId,
        'city': createLeadEntity.city,
        'inquired_for': createLeadEntity.inquiredFor,
        'data_fetched_by': createLeadEntity.dataFetchedBy,
        'LeadIncharge': 'Not Assigned',
        'rating': 0,
        'created_time': DateFormat('HH:mm:ss').format(DateTime.now()),
        'created_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'created_by': createLeadEntity.createdBy,
        'customer_state': 'New leads',
      };
      await customerRef
          .child('customer/${createLeadEntity.phoneNumber}')
          .update(customerData);
      return const Right(true);
    }catch(e){
      return Left(
        ErrorResponse(
          error: 'Error while creating lead $e',
          metaInfo: 'Catch triggered while creating lead!',
        ),
      );
    }
  }
}