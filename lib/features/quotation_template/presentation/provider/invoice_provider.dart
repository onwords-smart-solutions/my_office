import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../../model/client_model.dart';

class Invoice1Provider extends ChangeNotifier {
  ClientModel? customerDetails;

  ClientModel get getCustomerDetails => customerDetails!;

  void addCustomerDetails(ClientModel addDetailsOfCustomer) {
    customerDetails = addDetailsOfCustomer;

    log(addDetailsOfCustomer.name);
    log(addDetailsOfCustomer.street);
    log(addDetailsOfCustomer.address);
    log(addDetailsOfCustomer.docType);
    log(addDetailsOfCustomer.docCategory);
    log(addDetailsOfCustomer.gst!);
    log(addDetailsOfCustomer.docCategory);
    notifyListeners();
  }

  void deleteCustomerDetails(ClientModel deleteDetailsOfCustomer) {
    customerDetails = null;
    notifyListeners();
  }

  void clearAllData() {
    customerDetails = null;
    notifyListeners();
  }
}