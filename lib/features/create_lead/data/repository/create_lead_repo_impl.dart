import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_office/features/create_lead/domain/entity/create_lead_entity.dart';
import 'package:my_office/features/create_lead/domain/repository/create_lead_repository.dart';

class CreateLeadRepoImpl implements CreateLeadRepository {
  final customerRef = FirebaseDatabase.instance.ref();

  @override
  Future<void> createCustomerLead(CreateLeadEntity createLeadEntity) async {
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
        .child('customers/${createLeadEntity.phoneNumber}')
        .update(customerData);
  }
}
