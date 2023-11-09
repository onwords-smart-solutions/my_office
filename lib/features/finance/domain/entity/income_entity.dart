class IncomeEntity {
  final int amount;
  final String customerName;
  final String enteredBy;
  final String enteredDate;
  final String enteredTime;
  final String invoiceNumber;
  final String paidDate;
  final String paidTime;
  final String paymentMethod;
  final String productName;

  IncomeEntity({
    required this.productName,
    required this.enteredTime,
    required this.enteredDate,
    required this.enteredBy,
    required this.amount,
    required this.customerName,
    required this.invoiceNumber,
    required this.paidDate,
    required this.paidTime,
    required this.paymentMethod,
  });
}
