import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/constant/fonts/constant_font.dart';
import 'package:provider/provider.dart';
import '../models/client_model.dart';
import '../models/providers.dart';
import '../widgets/button_widget.dart';
import '../widgets/textFiled_widget.dart';
import 'added_product_table.dart';

class ClientDetails extends StatefulWidget {
  const ClientDetails({Key? key}) : super(key: key);

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  final formKey = GlobalKey<FormState>();

  TextEditingController clientName = TextEditingController();
  TextEditingController clientStreet = TextEditingController();
  TextEditingController clientAddress = TextEditingController();
  TextEditingController clientPhone = TextEditingController();
  TextEditingController clientGst = TextEditingController();

  String dropdownDocTypeValue = 'QUOTATION';
  String dropdownCategoryValue = 'GA';

  List<String> category = [
    'GA',
    'SH',
    'IT',
    'DL',
    'SS',
    'WTA',
    'AG',
    'VC',
  ];
  List<String> docType = ['QUOTATION', 'PROFORMA_INVOICE', 'INVOICE'];

  @override
  void dispose() {
    clientName.dispose();
    clientStreet.dispose();
    clientAddress.dispose();
    clientGst.dispose();
    clientPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<InvoiceProvider>(context, listen: false).clearAllData();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Client Details'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: ConstantColor.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Provider.of<InvoiceProvider>(context, listen: false)
                  .clearAllData();
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    height: 560,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFiledWidget(
                            controller: clientName,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            hintName: 'Client Name',
                            icon: const Icon(Icons.person),
                            maxLength: 35,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Name';
                              }
                              return null;
                            },
                          ).textInputFiled(),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFiledWidget(
                            controller: clientStreet,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            hintName: 'Client Location',
                            icon: const Icon(Iconsax.location5),
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Street';
                              }
                              return null;
                            },
                          ).textInputFiled(),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFiledWidget(
                            controller: clientAddress,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            hintName: 'Client Address',
                            icon: const Icon(Icons.location_city),
                            maxLength: 100,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Address';
                              }
                              return null;
                            },
                          ).textInputFiled(),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFiledWidget(
                            controller: clientPhone,
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            hintName: 'Phone Number',
                            icon: const Icon(Icons.call),
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Number';
                              }
                              return null;
                            },
                          ).textInputFiled(),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFiledWidget(
                            controller: clientGst,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            hintName: 'GST (optional)',
                            icon: const Icon(Icons.comment_bank),
                            maxLength: 15,
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter Customer GST';
                            //   }
                            //   return null;
                            // },
                          ).textInputFiled(),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 160,
                                child: DropdownButtonFormField<String>(
                                  hint: const Text("Doc-Type", style: TextStyle(fontWeight: FontWeight.w600),),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myFocusBorder(),
                                    // isDense: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Select Doc-Type';
                                    }
                                    return null;
                                  },
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownDocTypeValue = newValue!;
                                    });
                                  },
                                  items: docType.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 10, fontFamily: ConstantFonts.poppinsRegular, fontWeight: FontWeight.w600),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                width: 160,
                                child: DropdownButtonFormField<String>(
                                  hint: const Text("Category", style: TextStyle(fontWeight: FontWeight.w600),),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    fillColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    // hoverColor: Colors.black,
                                    focusedBorder: myFocusBorder(),
                                    // isDense: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Select Doc-Category';
                                    }
                                    return null;
                                  },
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownCategoryValue = newValue!;
                                    });
                                  },
                                  items: category.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,style: const TextStyle(fontWeight: FontWeight.w600),),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          //
                          // /// Document Type
                          // DropdownButtonFormField<String>(
                          //   hint: const Text('Doc-Type'),
                          //   decoration: InputDecoration(
                          //     counterText: '',
                          //     prefixIcon: const Icon(Icons.type_specimen),
                          //     hintText: 'Doc-Type',
                          //     // labelText: 'Doc-Type',
                          //     hintStyle: const TextStyle(
                          //         fontWeight: FontWeight.w400, fontFamily: ''),
                          //     border: myInputBorder(),
                          //     enabledBorder: myInputBorder(),
                          //     focusedBorder: myFocusBorder(),
                          //   ),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Select Doc-Type';
                          //     }
                          //     return null;
                          //   },
                          //   items: docType
                          //       .map<DropdownMenuItem<String>>((String value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value,
                          //       child: Text(value),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       dropdownDocTypeValue = newValue!;
                          //     });
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // /// Document Category
                          // DropdownButtonFormField<String>(
                          //   hint: const Text('Doc-Category'),
                          //   decoration: InputDecoration(
                          //     counterText: '',
                          //     prefixIcon: const Icon(Icons.category),
                          //     hintText: 'Doc-Category',
                          //     // labelText: 'Doc-Type',
                          //     hintStyle: const TextStyle(
                          //         fontWeight: FontWeight.w400, fontFamily: ''),
                          //     border: myInputBorder(),
                          //     enabledBorder: myInputBorder(),
                          //     focusedBorder: myFocusBorder(),
                          //   ),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Select Doc-Category';
                          //     }
                          //     return null;
                          //   },
                          //   items: category
                          //       .map<DropdownMenuItem<String>>((String value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value,
                          //       child: Text(value),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       dropdownCategoryValue = newValue!;
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Button('Next', () {
                    if (formKey.currentState!.validate()) {
                      Provider.of<InvoiceProvider>(context, listen: false)
                          .addCustomerDetails(ClientModel(
                              name: clientName.text,
                              street: clientStreet.text,
                              address: clientAddress.text,
                              phone: int.parse(clientPhone.text),
                              docType: dropdownDocTypeValue.toString(),
                              docCategory: dropdownCategoryValue.toString(),
                              gst: clientGst.text));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddProductScreen()));
                    }
                  }).button(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.5),
          width: 1.5,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.5),
          width: 1.5,
        ));
  }
}
