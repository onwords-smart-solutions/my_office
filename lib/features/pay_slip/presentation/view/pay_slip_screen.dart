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
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Hi,',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      TextSpan(
                        text: ' ${widget.user.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.deepPurple,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(5),
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Get your Pay slips here!',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const Gap(20),
              Stack(
                children: [
                  Container(
                    height: size.height * .15,
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
                          top: 25,
                          child: Text(
                            '"If to love each other is the job,\nthen the happy life is the\n salary"',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -10,
                          top: 5,
                          bottom: 10,
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
                      child: Lottie.asset('assets/animations/new_loading.json'))
                  : Center(
                      child: paySlipData.isEmpty
                          ? const Text(
                              'No Pay slips available!!',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
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
                                      elevation: 5,
                                      child: ListTile(
                                        title: Text(
                                          '$month PAY SLIP',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        position: PopupMenuPosition.under,
        elevation: 10.0,
        itemBuilder: (ctx) => List.generate(
          year.length,
          (index) {
            return PopupMenuItem(
              child: Text(
                year[index],
                style: const TextStyle(fontSize: 15),
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
            const Icon(Icons.calendar_month_rounded, color: Colors.deepPurple),
            Text(
              selectedYear,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
