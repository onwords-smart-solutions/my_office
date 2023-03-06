import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider_page.dart';

import 'preview_Screen.dart';

class AddIterm extends StatefulWidget {
  const AddIterm({Key? key}) : super(key: key);

  @override
  State<AddIterm> createState() => _AddItermState();
}

class _AddItermState extends State<AddIterm> {



  final date = DateTime.now();

  final SingleValueDropDownController itermNameController = SingleValueDropDownController();
  // TextEditingController itermNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController vatController = TextEditingController();
  TextEditingController fileName = TextEditingController();
  TextEditingController quotNo = TextEditingController();
  TextEditingController labAndInstall = TextEditingController();
  TextEditingController advancePaid = TextEditingController();
  TextEditingController discountController = TextEditingController();

  List productName = [];
  List productPrice = [];
  List productQuantity = [];
  List productVat = [];

  late SharedPreferences logData;

  String dropdownValue = 'QUOTATION';
  String category = 'GA';

  int advanceAmt = 0;
  int labCharge = 0;
  int discountAmount = 0;

  double subTotal = 0.0;

  bool gstNeed = false;
  bool labNeed = false;
  bool discountNeed = false;

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<DropDownValueModel> productList= const [
    DropDownValueModel(name: 'Local Server (Offline)', value: '1'),
    DropDownValueModel(name: 'Light Module (4 Light Board)', value: '2'),
    DropDownValueModel(name: 'Fan 5 Speed Module', value: '3'),
    DropDownValueModel(name: '30 Amps Board (1 Device)', value: '4'),
    DropDownValueModel(name: 'TV Module (1 Device)', value: '5'),
    DropDownValueModel(name: 'Server Rack', value: '6'),
    DropDownValueModel(name: 'Networking', value: '7'),
    DropDownValueModel(name: 'Wall Mount Tab', value: '8'),
    DropDownValueModel(name: 'Water Tank Automation', value: '9'),
    DropDownValueModel(name: 'Motion Sensor', value: '10'),
    DropDownValueModel(name: 'Timer Module', value: '11'),
    DropDownValueModel(name: '230V Curtain Motor + 2.2-meter\nfixing Accessories ', value: '12'),
    DropDownValueModel(name: '230V Curtain Motor + 3.2-meter\nfixing Accessories', value: '13'),
    DropDownValueModel(name: '230V Curtain Motor + 4.2-meter\nfixing Accessories', value: '14'),
    DropDownValueModel(name: '230V Curtain Motor + 5.2-meter\nfixing Accessories', value: '15'),
    DropDownValueModel(name: '230V Curtain Motor + 6.2-meter\nfixing Accessories', value: '16'),
    DropDownValueModel(name: '230V Curtain Motor + 7.2-meter\nfixing Accessories', value: '17'),
    DropDownValueModel(name: '230V Curtain Motor + 8.2-meter\nfixing Accessories', value: '18'),
    DropDownValueModel(name: 'Smart Home Configuration, Wiring,\nLink Establishment between\nApp&Server and Labour Charges', value: '19'),
    DropDownValueModel(name: 'SLIDING GATE(Up to 600Kg)', value: '20'),
    DropDownValueModel(name: 'SLIDING GATE(Up to 1000Kg)', value: '21'),
    DropDownValueModel(name: 'SWING GATE-ROLLER(Up to 500Kg Per Leaf)', value: '22'),
    DropDownValueModel(name: 'SWING GATE-ARM(Up to 350Kg Per Leaf)', value: '23'),
    DropDownValueModel(name: 'Safety Sensor', value: '24'),
    DropDownValueModel(name: 'App Control with Wi-Fi Module\nand Voice Integration', value: '25'),
    DropDownValueModel(name: 'Safety Motion Sensor', value: '26'),
    DropDownValueModel(name: '3 Button Switch', value: '27'),
    DropDownValueModel(name: 'Wireless Keypad Lock', value: '28'),
    DropDownValueModel(name: 'Video Door Phone', value: '29'),
    DropDownValueModel(name: 'RFID UHF312 12m Reader (RF)', value: '30'),
    DropDownValueModel(name: 'RFID C3200B Control Panel (RF)', value: '31'),
    DropDownValueModel(name: 'RFID UHF Price PerTag (RF)', value: '32'),
    DropDownValueModel(name: 'Extra Remote', value: '33'),
    DropDownValueModel(name: 'Electrical & Civil Planning,\nLabour & Installation', value: '34'),
    DropDownValueModel(name: 'Extra Rack for Sliding Gate', value: '35'),
    DropDownValueModel(name: 'Smart Cupboard Lock SL - C01', value: '36'),
    DropDownValueModel(name: 'Smart Digital Door lock Basic With WiFi SL- BW01', value: '37'),
    DropDownValueModel(name: 'Smart Glass Door Lock SL- G01', value: '38'),
    DropDownValueModel(name: 'Smart Door Lock Premium SL-P01', value: '39'),
    DropDownValueModel(name: 'Smart Door Lock Standard SL - S01', value: '40'),
    DropDownValueModel(name: 'Smart Indoor Lock Basic SI-B01', value: '41'),
    DropDownValueModel(name: 'Smart Indoor Lock Premium SI - P02', value: '42'),
    DropDownValueModel(name: 'Smart Door Lock Basic with Bluetooth SL - BB02', value: '43'),
    DropDownValueModel(name: 'Hub', value: '44'),
    DropDownValueModel(name: 'Hub Plus', value: '45'),
    DropDownValueModel(name: 'Hub 2', value: '46'),
    DropDownValueModel(name: 'Hub 2 Plus', value: '47'),
    DropDownValueModel(name: 'Rex', value: '48'),
    DropDownValueModel(name: 'Space Control', value: '49'),
    DropDownValueModel(name: 'Door Protect', value: '50'),
    DropDownValueModel(name: 'Door Protect Plus', value: '51'),
    DropDownValueModel(name: 'Motion Protect', value: '52'),
    DropDownValueModel(name: 'Motion Protect Plus', value: '53'),
    DropDownValueModel(name: 'Motion Protect Outdoor', value: '54'),
    DropDownValueModel(name: 'Hood for MPO', value: '55'),
    DropDownValueModel(name: 'Motion Cam Outdoor', value: '56'),
    DropDownValueModel(name: 'Dual Curtain Outdoor', value: '57'),
    DropDownValueModel(name: 'Motion Protect Curtain', value: '58'),
    DropDownValueModel(name: 'Combi Protect', value: '59'),
    DropDownValueModel(name: 'Glass Protect', value: '60'),
    DropDownValueModel(name: 'Motion Cam', value: '61'),
    DropDownValueModel(name: 'Street Siren', value: '62'),
    DropDownValueModel(name: 'Home Siren', value: '63'),
    DropDownValueModel(name: 'Street Siren Double Deck', value: '64'),
    DropDownValueModel(name: 'Leaks Protect', value: '65'),
    DropDownValueModel(name: 'Fire Protect', value: '66'),
    DropDownValueModel(name: 'Fire Protect Plus', value: '67'),
    DropDownValueModel(name: 'Keypad', value: '68'),
    DropDownValueModel(name: 'Key Pad Plus', value: '69'),
    DropDownValueModel(name: 'Batch of Pass (3 Pcs)', value: '70'),
    DropDownValueModel(name: 'Batch of Pass (10 Pcs)', value: '71'),
    DropDownValueModel(name: 'Batch of Pass (100 Pcs)', value: '72'),
    DropDownValueModel(name: 'Batch of Tag (3 Pcs)', value: '73'),
    DropDownValueModel(name: 'Batch of Tag (10 Pcs)', value: '74'),
    DropDownValueModel(name: 'Batch of Tag (100 Pcs)', value: '75'),
    DropDownValueModel(name: 'Button', value: '76'),
    DropDownValueModel(name: 'Ajax Double Button', value: '77'),
  ];

  @override
  void initState() {
    itermNameController;
    priceController;
    quantityController;
    vatController;
    fileName;
    quotNo;
    labAndInstall;

    advancePaid;
    discountController;
    super.initState();
  }

  @override
  void dispose() {
    itermNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    vatController.dispose();
    fileName.dispose();
    quotNo.dispose();
    labAndInstall.dispose();
    advancePaid.dispose();
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<TaskData>(
        builder: (context, taskData,child) {
          // print("taskData.tasks ${taskData.tasks.length}");
          final task = taskData.tasks.length == 2 ? taskData.tasks[1]: taskData.tasks[0];
          // final val = taskData.subTotalValue;
          // if(val.isEmpty){
          //   // print("aasswipe");
          // }else{
          //   subTotal = val.map((e) => e.quantity*e.amount).reduce((value, element) => value + element);
          // }
          // final netTotal = val.map((item) => item.amount * item.quantity).reduce((item1, item2) => item1 + item2);

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                "Add Items",
                style: TextStyle(
                    fontFamily: 'Nexa',
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: height * 0.018),
              ),
              centerTitle: true,
              leading:   GestureDetector(
                child: Image.asset(
                  'assets/back arrow.png',
                  scale: 2.3,
                  color: const Color(0xff00bcd4),
                ),
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              // actions: [
              //   GestureDetector(
              //     child: Icon(
              //       Icons.account_circle_outlined,
              //       color: const Color(0xff00bcd4),
              //       size: height * 0.03,
              //     ),
              //     onTap: () {
              //       setState(() {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => const AccountScreen()));
              //       });
              //     },
              //   ),
              //   SizedBox(width: width*0.05,)
              //
              // ],
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height * 0.90,
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.01, horizontal: width * 0.05),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date : ${DateFormat("dd.MM.yyyy").format(date)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.012,
                                fontFamily: 'Nexa',
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            width: width * 0.9,
                            height: height * 0.04,
                            decoration: BoxDecoration(
                                color: const Color(0xff00bcd4),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'Products',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * 0.019,
                                    fontFamily: 'Nexa',
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                            width: width * 0.9,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'To :   ${task.name}',
                                  // style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: height * 0.012,
                                  //     fontFamily: 'Avenir',
                                  //     color: Colors.black),
                                ),
                                // IconButton(
                                //     onPressed: () {},
                                //     icon: Image.asset(
                                //       'assets/etit1.png',
                                //       scale: 3.5,
                                //     ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            width: width * 0.9,
                            height: height * 0.09,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Add Item",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.012,
                                  fontFamily: 'Nexa',
                                ),),
                                IconButton(
                                  onPressed: () {
                                    showAnotherAlertDialog(context,height,width);
                                  },
                                  icon: Image.asset(
                                    'assets/add.png',
                                    color: const Color(0xff00bcd4),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                            width: width * 0.9,
                            height: height * 0.08,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * 0.15,
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: height * 0.012,
                                      fontFamily: 'Avenir',
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: ' Name',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: height * 0.012,
                                        fontFamily: 'Nexa',
                                      ),
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.black.withOpacity(0.4),
                                  endIndent: 25,
                                  indent: 25,
                                  thickness: 3,
                                ),
                                SizedBox(
                                  width: width * 0.16,
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: height * 0.012,
                                      fontFamily: 'Avenir',
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Quantity',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: height * 0.012,
                                        fontFamily: 'Nexa',
                                      ),
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.black.withOpacity(0.4),
                                  endIndent: 25,
                                  indent: 25,
                                  thickness: 3,
                                ),
                                SizedBox(
                                  width: width * 0.12,
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: height * 0.012,
                                      fontFamily: 'Avenir',
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Rate',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: height * 0.012,
                                        fontFamily: 'Nexa',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: height * 0.18,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0),bottomRight:Radius.circular(20.0) ),
                            ),
                            child:ListView.builder(
                              // shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              itemCount: productName.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: (){
                                    showDeleteDialog(context,index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Table(
                                      // border: TableBorder.all(),
                                      children: [
                                        buildRow([
                                          '${productName[index]}','${productQuantity[index]}','${productPrice[index]}',]),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                            height: height * 0.27,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Doc-Type",style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.012,
                                          fontFamily: 'Nexa',
                                          color: Colors.black),),
                                      DropdownButton<String>(
                                        value: dropdownValue,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.black),
                                        // underline: Container(
                                        //   height: 0.5,
                                        //   color: Colors.black,
                                        // ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        items: <String>['QUOTATION','INVOICE']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Category",style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.012,
                                          fontFamily: 'Nexa',
                                          color: Colors.black),),
                                      DropdownButton<String>(
                                        value: category,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.black),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            category = newValue!;
                                          });
                                        },
                                        items: <String>['GA','SH','IT','DL','SS','WTA','AG']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("GST Need : ",style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.012,
                                          fontFamily: 'Nexa',
                                          color: Colors.black),),
                                      Checkbox(
                                          value: gstNeed,
                                          onChanged: (val){
                                            setState((){
                                              gstNeed = val!;
                                            });
                                          }
                                      )
                                    ],
                                  ),
                                  ///NEED DISCOUNT
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Discount : ",style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.012,
                                          fontFamily: 'Nexa',
                                          color: Colors.black),),
                                      Checkbox(
                                          value: discountNeed,
                                          onChanged: (val){
                                            setState((){
                                              discountNeed = val!;
                                            });
                                          }
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      (discountNeed)? Text("Give Discount : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: height * 0.012,
                                            fontFamily: 'Nexa',
                                            color: Colors.black),):const Text(""),
                                      (discountNeed)? SizedBox(
                                        width: width*0.40,
                                        child: TextFormField(
                                          onChanged: (val){
                                            if(val.isNotEmpty)
                                            {
                                              setState((){
                                                discountAmount = int.parse(val);
                                              });
                                            }
                                          },
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: height * 0.012,
                                            fontFamily: 'Avenir',
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: ' Enter Amount',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              fontFamily: 'Nexa',),
                                          ),
                                          controller: discountController,
                                        ),
                                      ):const Text(""),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      dropdownValue=="INVOICE"? Text("Advance Amount",style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.012,
                                          fontFamily: 'Nexa',
                                          color: Colors.black),):const Text(""),
                                      dropdownValue=="INVOICE"? SizedBox(
                                        width: width*0.40,
                                        child: TextFormField(
                                          onChanged: (val){
                                            if(val.isNotEmpty)
                                            {
                                              setState(() {
                                                advanceAmt = int.parse(val);
                                              });
                                            }
                                          },
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: height * 0.012,
                                            fontFamily: 'Avenir',
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: ' Advance Paid',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              fontFamily: 'Nexa',),
                                          ),
                                          controller: advancePaid,
                                        ),
                                      ):const Text(""),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          SizedBox(
                            width: width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if(productName.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text('Please select product'),
                                          duration: Duration(seconds: 1),));
                                      }else{
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PreviewScreen(
                                                  doctype: dropdownValue,
                                                  category: category,
                                                  advanceAmt: advanceAmt,
                                                  // labAndInstall: labCharge,
                                                  gstValue: gstNeed,
                                                  discountAmount: discountAmount,
                                                  discountNeed: discountNeed,
                                                  // labValue: labNeed,
                                                ))).then((value){
                                          setState(() {
                                            // labAndInstall.clear();
                                            advancePaid.clear();
                                            advanceAmt = 0;
                                            // labCharge = 0;
                                          });
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: width * 0.28,
                                    height: height * 0.05,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff00bcd4),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            offset: const Offset(8, 8),
                                            blurRadius: 10,
                                            spreadRadius: 0)
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: height * 0.013,
                                            fontFamily: 'Nexa',
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  TableRow buildRow(List<String> cells,{bool isHeader = false}) => TableRow(
    children: cells.map(
          (cell) {
        final style =TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        );
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(cell,style: style,),
          ),
        );
      },
    ).toList(),
  );


  showDeleteDialog(BuildContext context,int index){
    Widget okButton = TextButton(
      child: const Text(" ok "),
      onPressed: () {
        setState((){
          productName.removeAt(index);
          productQuantity.removeAt(index);
          productVat.removeAt(index);
          productPrice.removeAt(index);
          Provider.of<TaskData>(context,listen: false).deleteTask(index);
          Provider.of<TaskData>(context,listen: false).clearSubtotal(index);
          Navigator.pop(context, false);
        });
      },
    );
    Widget cancelButton = TextButton(
      child: const Text(" Cancel "),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: const Text("Do you want to delete ?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  showAnotherAlertDialog(BuildContext context,height,width) {
    // Create button
    Widget okButton = TextButton(
      child: const Text(" ok "),
      onPressed: () {
        if(formKey.currentState!.validate()){
          if(!mounted) return;
          setState((){
            productName.add(itermNameController.dropDownValue?.name);
            productPrice.add(priceController.text);
            productQuantity.add(quantityController.text);
            productVat.add(vatController.text);
          });
          Provider.of<TaskData>(context,listen: false).addInvoiceListData(itermNameController.dropDownValue!.name.toString(),int.parse(quantityController.text), double.parse(priceController.text));
          Provider.of<TaskData>(context,listen: false).addSubTotal(int.parse(quantityController.text),double.parse(priceController.text));
          Navigator.pop(context, false);
          itermNameController.clearDropDown();
          priceController.clear();
          quantityController.clear();
          vatController.clear();
        }
      },
    );
    Widget cancelButton = TextButton(
      child: const Text(" Cancel "),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: const Text(
        "  Data entry ",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: formKey,
        child: SizedBox(
          height: height*0.40,
          width: width*1.0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropDownTextField(
                  // initialValue: "name4",
                  controller: itermNameController,
                  clearOption: true,
                  enableSearch: true,
                  // dropDownIconProperty: IconProperty(icon: Icons.arrow_drop_down,color: Colors.black),
                  clearIconProperty: IconProperty(color: Colors.black,icon: Icons.clear),
                  // dropdownColor: Colors.orange,
                  searchDecoration: const InputDecoration(
                      hintText: "Select Product"),
                  validator: (value) {
                    if (value == null) {
                      return "Required Product Name";
                    } else {
                      return null;
                    }
                  },
                  dropDownItemCount: 6,
                  dropDownList: productList,
                  onChanged: (val) {},
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'quantity'),
                    controller: quantityController,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'amount'),
                    controller: priceController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () async { return false; },
        child: alert);
      },
    );
  }

// showFileNameDialog(BuildContext context,task,height,width,taskData) {
//   // Create button
//   Widget okButton =  ButtonWidget(
//     text: 'GENERATE PDF',
//     onClicked: () async {
//       final date = DateTime.now();
//       // final dueDate = date.add(Duration(days: 7));
//       final invoice = Invoice(
//         quotNo: int.parse(quotNo.text),
//         fileName: fileName.text,
//         supplier: Supplier(
//           name: supplierName,
//           street: supplierStreet,
//           address: supplierAddress,
//           phone: supplierPhone,
//           email: supplierEmail,
//           website: supplierWebsite,
//         ),
//         customer: Customer(
//           name: task.name,
//           street: task.street,
//           address: task.address,
//           phone: task.phone,
//         ),
//         info: InvoiceInfo(
//           date: date,
//           // dueDate: dueDate,
//           // description: 'Description...',
//           // number: '${DateTime.now().year}-9999',
//         ),
//         items: taskData.invoiceListData,
//         docType: dropdownValue, cat: category, advancePaid: advanceAmt, labAndInstall: labCharge,
//       );
//
//       final pdfFile = await PdfInvoiceApi.generate(invoice);
//
//       PdfApi.openFile(pdfFile).then((value){
//         fileName.clear();
//         quotNo.clear();
//         labAndInstall.clear();
//         advancePaid.clear();
//       });
//     },
//   );
//   Widget cancelButton = TextButton(
//     child: const Text(" Cancel "),
//     onPressed: () {
//       Navigator.pop(context, false);
//     },
//   );
//   // Create AlertDialog
//   final alert = StatefulBuilder(
//       builder: (context, setState) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//         content: Container(
//           height: height*0.30,
//           width: width*1.0,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     DropdownButton<String>(
//                       value: dropdownValue,
//                       icon: const Icon(Icons.arrow_downward),
//                       elevation: 16,
//                       style: const TextStyle(color: Colors.black),
//                       underline: Container(
//                         height: 2,
//                         color: Colors.black,
//                       ),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                       items: <String>['QUOTATION','INVOICE']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                     DropdownButton<String>(
//                       value: category,
//                       icon: const Icon(Icons.arrow_downward),
//                       elevation: 16,
//                       style: const TextStyle(color: Colors.black),
//                       underline: Container(
//                         height: 2,
//                         color: Colors.black,
//                       ),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           category = newValue!;
//                         });
//                       },
//                       items: <String>['GA','SH','IT','DL','SS','WTA']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(20.0),
//                   child: TextFormField(
//                     decoration: const InputDecoration(hintText: 'file name'),
//                     controller: fileName,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(20.0),
//                   child: TextFormField(
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(hintText: 'Quotation no'),
//                     controller: quotNo,
//                   ),
//                 ),
//                 dropdownValue=="INVOICE"? Container(
//                   padding: const EdgeInsets.all(20.0),
//                   child: TextFormField(
//                     onChanged: (val){
//                       setState((){
//                         labCharge = int.parse(val);
//                         print(labCharge);
//                       });
//                     },
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(hintText: 'Labour and Installation Amount'),
//                     controller: labAndInstall,
//                   ),
//                 ):Container(),
//                 dropdownValue=="INVOICE"? Container(
//                   padding: const EdgeInsets.all(20.0),
//                   child: TextFormField(
//                     onChanged: (val){
//                       setState(() {
//                         advanceAmt = int.parse(val);
//                         print(advanceAmt);
//                       });
//                     },
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(hintText: 'Advance Paid'),
//                     controller: advancePaid,
//                   ),
//                 ):Container(),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           okButton,
//           cancelButton,
//         ],
//       ));
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
}