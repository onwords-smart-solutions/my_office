import 'package:flutter/material.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';

class CustomerItem extends StatelessWidget {
  final int index;

  final Map<Object?, Object?> customerInfo;

  const CustomerItem(
      {Key? key, required this.customerInfo, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color tileColor=Colors.grey;

    switch(customerInfo['customer_state'].toString().toLowerCase()){
      case 'rejected':tileColor=Colors.redAccent;break;
      case 'following up':tileColor=Colors.greenAccent;break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      margin: const EdgeInsets.all( 3.0),
      decoration: BoxDecoration(
          color: tileColor, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customerInfo['name'].toString(),
            style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
          ),
          Text(customerInfo['customer_state'].toString(),
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsRegular, fontSize: 12.0)),
          Text(customerInfo['phone_number'].toString(),
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsRegular, fontSize: 12.0)),
        ],
      ),
    );
  }
}
