import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:my_office/PR/invoice_generator/models/table_list.dart';
import 'client_model.dart';

class InvoiceProvider extends ChangeNotifier {


  /// Invoice Table Details
  List<ListOfTable> invoiceProductDetails = [];
  List<ListOfTable> get getProductDetails => invoiceProductDetails;
  void addProduct(ListOfTable addData) {
    final index = invoiceProductDetails
        .indexWhere((element) => element.productName == addData.productName);
    if (index > -1) {
      final oldData = invoiceProductDetails[index];
      final qty = oldData.productQuantity + addData.productQuantity;
      final newData = ListOfTable(
          productName: addData.productName,
          productQuantity: qty,
          productPrice: addData.productPrice,
          subTotalList: qty * addData.productPrice,
          minPrice: addData.minPrice,
          obcPrice: addData.obcPrice);

      invoiceProductDetails[index] = newData;
    } else {
      invoiceProductDetails.add(addData);
    }

    // log(addData.productName);
    // log(addData.productPrice.toString());
    // log(addData.productQuantity.toString());
    notifyListeners();
  }
  void deleteProduct(String productName) {
    final index = invoiceProductDetails
        .indexWhere((element) => element.productName == productName);
    if (index > -1) {
      invoiceProductDetails.removeAt(index);
      notifyListeners();
    }


  }

  /// Customer Details
  ClientModel? customerDetails;
  ClientModel get getCustomerDetails => customerDetails!;
  void addCustomerDetails(ClientModel addDetailsOfCustomer){
    customerDetails = addDetailsOfCustomer;

    log(addDetailsOfCustomer.name);
    log(addDetailsOfCustomer.street);
    log(addDetailsOfCustomer.address);
    log(addDetailsOfCustomer.docType);
    log(addDetailsOfCustomer.docCategory);
    log(addDetailsOfCustomer.gst!);
    log(addDetailsOfCustomer.docType);
    log(addDetailsOfCustomer.docCategory);
    notifyListeners();
  }
  void deleteCustomerDetails(ClientModel deleteDetailsOfCustomer){
    customerDetails = null;
    notifyListeners();
  }


  void clearAllData() {
    invoiceProductDetails.clear();
    customerDetails = null;
    notifyListeners();
  }

}
