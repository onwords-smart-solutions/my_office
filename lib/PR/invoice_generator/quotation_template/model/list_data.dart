import 'package:my_office/PR/invoice_generator/quotation_template/model/table_list.dart';

List<ListOfTable> smartHomeData = [
  ListOfTable(productName: 'Local Server', productQuantity: 1, productPrice: 48500, subTotalList: 48500),
  ListOfTable(productName: 'Relay Module 4CH', productQuantity: 3, productPrice: 6000, subTotalList: 18000),
  ListOfTable(productName: 'Fan 5 Speed Module 1CH', productQuantity: 2, productPrice: 7000, subTotalList: 14000),
  ListOfTable(productName: 'App and Voice Integration', productQuantity: 1, productPrice: 0, subTotalList: 0),
  ListOfTable(productName: 'Labour', productQuantity: 1, productPrice: 5000, subTotalList: 5000),
];

List<ListOfTable> slidingGateData = [
  ListOfTable(productName: 'Sliding Gate Motor - 600KG', productQuantity: 1, productPrice: 34696, subTotalList: 34696),
  ListOfTable(productName: 'Sliding Gate 600 KG Controller', productQuantity: 1, productPrice: 9999, subTotalList: 9999),
  ListOfTable(productName: 'Safety Sensor', productQuantity: 1, productPrice: 3304, subTotalList: 3304),
  // ListOfTable(productName: 'Labour', productQuantity: 1, productPrice: 5000, subTotalList: 5000),
];

List<ListOfTable> swingGateData = [
  ListOfTable(productName: 'Swing Gate Arm - 600KG', productQuantity: 1, productPrice: 40000, subTotalList: 40000),
  ListOfTable(productName: 'Swing Gate Arm Controller', productQuantity: 1, productPrice: 9999, subTotalList: 9999),
  // ListOfTable(productName: 'Safety Sensor', productQuantity: 1, productPrice: 3304, subTotalList: 3304),
  // ListOfTable(productName: 'Labour', productQuantity: 1, productPrice: 5000, subTotalList: 5000),
];

double get getSmartHomeSubTotal{
  double total = 0.0;
  for(var item in smartHomeData){
    total += item.subTotalList;
  }
  return total;
}

double get slidingGateSubTotal{
  double total = 0.0;
  for(var item in slidingGateData){
    total += item.subTotalList;
  }
  return total;
}

double get swingGateSubTotal{
  double total = 0.0;
  for(var item in swingGateData){
    total += item.subTotalList;
  }
  return total;
}
