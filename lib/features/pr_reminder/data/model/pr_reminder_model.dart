class PrReminderModel {
  String city;
  String createdBy;
  String createdDate;
  String createdTime;
  String customerId;
  String customerName;
  String dataFetchedBy;
  String emailId;
  String enquiredFor;
  String leadInCharge;
  String phoneNumber;
  String rating;
  String state;
  String updatedBy;

  PrReminderModel({
    required this.customerName,
    required this.dataFetchedBy,
    required this.city,
    required this.emailId,
    required this.createdBy,
    required this.phoneNumber,
    required this.updatedBy,
    required this.leadInCharge,
    required this.state,
    required this.createdDate,
    required this.createdTime,
    required this.customerId,
    required this.enquiredFor,
    required this.rating,
  });

  factory PrReminderModel.fromMap(Map<Object?, Object?> prData) {
    return PrReminderModel(
      city: prData['City'].toString(),
      createdBy: prData['Created_by'].toString(),
      createdDate: prData['Created_date'].toString(),
      createdTime: prData['Created_time'].toString(),
      customerId: prData['Customer_id'].toString(),
      customerName: prData['Customer_name'].toString(),
      dataFetchedBy: prData['Data_fetched_by'].toString(),
      emailId: prData['Email_id'].toString(),
      enquiredFor: prData['Enquired_for'].toString(),
      leadInCharge: prData['Lead_in_charge'].toString(),
      phoneNumber: prData['Phone_number'].toString(),
      rating: prData['Rating'].toString(),
      state: prData['State'].toString(),
      updatedBy: prData['Updated_by'].toString(),
    );
  }
}
