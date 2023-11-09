class ExpenseEntity {
  final int amount;
  final String enteredBy;
  final String enteredDate;
  final String enteredTime;
  final String productName;
  final String purchasedDate;
  final String purchasedFor;
  final String purchasedTime;
  final String service;

  ExpenseEntity({
    required this.amount,
    required this.enteredBy,
    required this.enteredDate,
    required this.enteredTime,
    required this.productName,
    required this.purchasedDate,
    required this.purchasedFor,
    required this.purchasedTime,
    required this.service,
  });
}
