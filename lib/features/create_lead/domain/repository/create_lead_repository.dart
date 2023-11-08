import 'package:my_office/features/create_lead/domain/entity/create_lead_entity.dart';

abstract class CreateLeadRepository{
  Future<void> createCustomerLead(CreateLeadEntity createLeadEntity);
}