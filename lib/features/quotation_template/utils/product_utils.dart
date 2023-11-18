import 'list_of_table_utils.dart';

List<ListOfTable> smartHomeData = [
  ListOfTable(
    productName: 'Local Server',
    productQuantity: 1,
    productPrice: 48500,
    subTotalList: 48500,
  ),
  ListOfTable(
    productName: 'Relay Module 4CH',
    productQuantity: 3,
    productPrice: 6000,
    subTotalList: 18000,
  ),
  ListOfTable(
    productName: 'Fan 5 Speed Module 1CH',
    productQuantity: 2,
    productPrice: 7000,
    subTotalList: 14000,
  ),
  ListOfTable(
    productName: 'App and Voice Integration',
    productQuantity: 1,
    productPrice: 0,
    subTotalList: 0,
  ),
  ListOfTable(
    productName: 'Labour',
    productQuantity: 1,
    productPrice: 5000,
    subTotalList: 5000,
  ),
];

List<ListOfTable> slidingGateData = [
  ListOfTable(
    productName: 'Sliding Gate Motor - 600KG',
    productQuantity: 1,
    productPrice: 41697,
    subTotalList: 41697,
  ),
  ListOfTable(
    productName: 'Sliding Gate 600 KG Controller',
    productQuantity: 1,
    productPrice: 9999,
    subTotalList: 9999,
  ),
  ListOfTable(
    productName: 'Safety Sensor',
    productQuantity: 1,
    productPrice: 3304,
    subTotalList: 3304,
  ),
];

List<ListOfTable> swingGateData = [
  ListOfTable(
    productName: 'Swing Gate Arm Motor - 600KG',
    productQuantity: 1,
    productPrice: 47001,
    subTotalList: 47001,
  ),
  ListOfTable(
    productName: 'Swing Gate Arm Controller',
    productQuantity: 1,
    productPrice: 9999,
    subTotalList: 9999,
  ),
];

double get getSmartHomeSubTotal {
  double total = 0.0;
  for (var item in smartHomeData) {
    total += item.subTotalList;
  }
  return total;
}

double get slidingGateSubTotal {
  double total = 0.0;
  for (var item in slidingGateData) {
    total += item.subTotalList;
  }
  return total;
}

double get swingGateSubTotal {
  double total = 0.0;
  for (var item in swingGateData) {
    total += item.subTotalList;
  }
  return total;
}
