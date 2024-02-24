import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/pay_slip/presentation/view/view_month_pdf_screen.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';

class PaySlip extends StatefulWidget {
  final UserEntity user;

  const PaySlip({super.key, required this.user});

  @override
  State<PaySlip> createState() => _PaySlipState();
}

class _PaySlipState extends State<PaySlip> {
  String currentYear = DateFormat.y().format(DateTime.now());
  bool isLoading = false;

  final List<String> year = [
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
  ];

  final Map<String, String> paySlipData = {};

  Future<void> getPaySlipsPdf(String year) async {
    setState(() {
      isLoading = true;
      paySlipData.clear();
    });
    final ref = FirebaseStorage.instance.ref('EMPLOYEE_PAY_SLIPS/$year/');
    final yearData = await ref.listAll();
    for (var month in yearData.prefixes) {
      try {
        final url =
            await month.child('${widget.user.uid}.pdf').getDownloadURL();
        final split = month.child('${widget.user.uid}.pdf').fullPath.split('/');
        String monthData = split[2];
        paySlipData[monthData] = url;
      } catch (e) {
        print('Error from : $e');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getPaySlipsPdf(currentYear);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Pay slips', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 25,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              Stack(
                children: [
                  Container(
                    height: size.height * .2,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
                    ),
                    child: const Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 30,
                          child: Text(
                            '"A lot of people work to earn.\nAnd, while at it, \nthey forget to learn."',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -25,
                          top: 25,
                          bottom: 0,
                          child: Image(
                            image: AssetImage(
                              'assets/pay_slip_screen.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildDropDown(currentYear),
                ],
              ),
              isLoading
                  ? Center(
                      child:  Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
                      Lottie.asset('assets/animations/loading_light_theme.json'):
                      Lottie.asset('assets/animations/loading_dark_theme.json'),)
                  : Center(
                      child: paySlipData.isEmpty
                          ? Text(
                              'No Pay slips available!!',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SizedBox(
                                height: MediaQuery.sizeOf(context).height * .6,
                                width: double.infinity,
                                child: ListView.builder(
                                  itemCount: paySlipData.length,
                                  itemBuilder: (context, index) {
                                    String month =
                                        paySlipData.keys.elementAt(index);
                                    String downloadUrl = paySlipData[month]!;
                                    return Card(
                                      surfaceTintColor: Colors.transparent,
                                      color: Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.grey.withOpacity(.2) : Colors.grey.shade300,
                                      child: ListTile(
                                        title: Text(
                                          '$month PAY SLIP',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ViewMonthPdf(
                                                name: widget.user.name,
                                                pdf: downloadUrl,
                                                month: month,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropDown(String selectedYear) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PopupMenuButton(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        position: PopupMenuPosition.under,
        elevation: 10.0,
        itemBuilder: (ctx) => List.generate(
          year.length,
          (index) {
            return PopupMenuItem(
              child: Text(
                year[index],
                style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor,),
              ),
              onTap: () {
                setState(() {
                  currentYear = year[index];
                  getPaySlipsPdf(currentYear);
                });
              },
            );
          },
        ),
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_rounded,color: Theme.of(context).primaryColor,),
            const Gap(5),
            Text(
              selectedYear,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
