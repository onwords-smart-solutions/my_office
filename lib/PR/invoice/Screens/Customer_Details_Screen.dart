import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider_page.dart';
import 'Add_iterms_Screen.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({Key? key}) : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {

  TextEditingController clientName = TextEditingController();
  TextEditingController clientStreet = TextEditingController();
  TextEditingController clientAddress = TextEditingController();
  TextEditingController clientPhone = TextEditingController();
  TextEditingController clientGst = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final customerName = TextEditingController();
  final email = TextEditingController();
  final number = TextEditingController();


  // StreamSubscription? subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;


  // getConnectivity() {
  //   subscription = Connectivity()
  //       .onConnectivityChanged
  //       .listen((ConnectivityResult result) async {
  //     isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //     if (!isDeviceConnected && isAlertSet == false) {
  //       showDialogBox();
  //       setState(() {
  //         isAlertSet = true;
  //       });
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   // getConnectivity();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   subscription!.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:    Text(
          "Customer Details",
          style: TextStyle(
              fontFamily: 'Nexa',
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: height * 0.018),
        ),
        centerTitle: true,
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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.09),
                height: height * 0.78,
                decoration:  BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.08, vertical: height * 0.05),
                      height: height * 0.60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            controller: clientName,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_circle_outlined,color: const Color(0xff00bcd4),size: height*0.029,),
                                hintText: ' Customer Name',
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Nexa')),
                          ),
                          TextFormField(
                            controller: clientStreet,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon:
                                Image.asset(
                                  'assets/location.png',
                                  scale: 2.9,
                                  color: const Color(0xff00bcd4),
                                ),
                                hintText: ' Address',
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Nexa')),
                          ),
                          TextFormField(
                            controller: clientAddress,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter City Name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Image.asset(
                                  'assets/location.png',
                                  scale: 2.9,
                                  color: const Color(0xff00bcd4),
                                ),
                                hintText: ' City',
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Nexa')),
                          ),
                          TextFormField(
                            controller: clientPhone,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty || value.length!=10) {
                                return 'Please enter valid Phone Number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Image.asset(
                                  'assets/number.png',
                                  scale: 2.9,
                                  color: const Color(0xff00bcd4),
                                ),
                                hintText: ' Phone Number',
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Nexa')),
                          ),
                          TextFormField(
                            controller: clientGst,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.name,
                            maxLength: 15,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.rate_review_outlined,size: height*0.04,color: const Color(0xff00bcd4),),
                                hintText: 'GSTIN (optinal)',
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: '')),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                           setState(() {
                             Provider.of<TaskData>(context,listen: false).addTask(
                                 clientName.text,
                                 clientStreet.text,
                                 clientAddress.text,
                                 int.parse(clientPhone.text),
                                 clientGst.text.toUpperCase()
                             );
                             Navigator.push(context, MaterialPageRoute(builder: (context) => const AddIterm()));
                           });
                         }
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
                                offset: const Offset(8,8),
                                blurRadius: 10,
                                spreadRadius: 0,
                            )
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
      ),
    );
  }

  showDialogBox() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Oops! No Connection"),
        content: const Text("Please check your internet connection"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Cancel');
              setState(() {
                isAlertSet = false;
              });
              isDeviceConnected =
              await InternetConnectionChecker().hasConnection;
              if (!isDeviceConnected) {
                showDialogBox();
                setState(() {
                  isAlertSet = true;
                });
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

}
