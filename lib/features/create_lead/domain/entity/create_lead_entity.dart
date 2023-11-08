import 'package:intl/intl.dart';

class CreateLeadEntity {
  final String name;
  final String phoneNumber;
  final String emailId;
  final String city;
  final String inquiredFor;
  final String dataFetchedBy;
  final String createdBy;
  final String customerState;
  final int rating;
  final DateTime createdTime;

  CreateLeadEntity({
    required this.name,
    required this.phoneNumber,
    required this.emailId,
    required this.city,
    required this.inquiredFor,
    required this.dataFetchedBy,
    required this.createdBy,
    this.customerState = 'New leads',
    this.rating = 0,
    DateTime? createdTime,
  }) : createdTime = createdTime ?? DateTime.now();

  Map<String, dynamic> toFirebaseMap() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'email_id': emailId,
      'city': city,
      'inquired_for': inquiredFor,
      'data_fetched_by': dataFetchedBy,
      'LeadIncharge': 'Not Assigned',
      'rating': rating,
      'created_time': DateFormat('HH:mm:ss').format(createdTime),
      'created_date': DateFormat('yyyy-MM-dd').format(createdTime),
      'created_by': createdBy,
      'customer_state': customerState,
    };
  }
}
