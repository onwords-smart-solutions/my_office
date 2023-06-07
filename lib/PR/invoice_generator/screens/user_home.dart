import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../Constant/colors/constant_colors.dart';
import 'client_detials.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ConstantColor.backgroundColor
      ),
      backgroundColor:  ConstantColor.background1Color,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,

        child: const Center(
          child: Icon(Icons.add),
        ),
        onPressed: () {
          // Navigator.pushNamed(context,'/invoiceGenerator');
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ClientDetails()));
        },
      ),
      body: Column(
        children: [
          invoiceStatusContainer('Finish'),
          invoiceStatusContainer('Resume'),
        ],
      ),
    );
  }

  Widget invoiceStatusContainer(
    String title,
  ) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.lightBlueAccent.withOpacity(.5),
      ),
      child: Center(child: Text(title),
      ),
    );
  }
}
