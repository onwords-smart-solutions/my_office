import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/PR/customer_item.dart';
import 'package:my_office/util/main_template.dart';

class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.background1Color,
      body: MainTemplate(
          subtitle: 'Search your leads here!',
          bgColor: ConstantColor.background1Color,
          templateBody: buildScreen()),
    );
  }

  Widget buildScreen() {
    return Column(
      children: [
        Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 2.0,color: Color(0xffA4A1A6)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Search'),
                ),
              ),
              Image.asset('assets/search.png',scale: 3.0,),

              Container(width: 2.0,height:30.0,color: Colors.black87),
              Image.asset('assets/filter.png',scale: 3.0,),
            ],
          ),
        )
      ],
    );
  }

  Widget buildCustomerList() {
    final ref = FirebaseDatabase.instance.ref();
    return StreamBuilder(
      stream: ref.child('customer').once().asStream(),
      builder: (ctx, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            final List<Map<Object?, Object?>> customerInfo = [];
            final data = snapshot.data;

            for (var i in data!.snapshot.children) {
              final Map<Object?, Object?> data =
                  i.value as Map<Object?, Object?>;
              customerInfo.add(data);
            }

            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: customerInfo.length > 50 ? 50 : customerInfo.length,
                itemBuilder: (c, index) {
                  return CustomerItem(
                      index: index, customerInfo: customerInfo[index]);
                });
          }
          return const SizedBox();
        }
      },
    );
  }
}
