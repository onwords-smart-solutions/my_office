import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../models/view_visit_model.dart';
import '../util/screen_template.dart';
import 'visitList.dart';

class VisitCheckScreen extends StatefulWidget {
  const VisitCheckScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VisitCheckScreen> createState() => _VisitCheckScreenState();
}

class _VisitCheckScreenState extends State<VisitCheckScreen> {
  List<VisitViewModel> allVisits = [];
  bool isLoading = true;
  dynamic visitCheckData;
  final today = DateTime.now();
  DatabaseReference visitCheck = FirebaseDatabase.instance.ref('visit');
  DateTime now = DateTime.now();

  var formatterDate = DateFormat('yyyy-MM-dd');
  var formatterMonth = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  String? selectedDate;
  String? selectedMonth;
  String? selectedYear;

  datePicker() async {


    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (newDate == null) return;
    setState(() {
      selectedDate = formatterDate.format(newDate);
      selectedMonth = formatterDate.format(newDate);
      selectedYear = formatterDate.format(newDate);
      checkVisitData(newDate.year.toString(), newDate.month.toString(),
          newDate.day.toString());
    });
  }

  @override
  void initState() {
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterMonth.format(now);
    selectedYear = formatterYear.format(now);
    checkVisitData(
        today.year.toString(), today.month.toString(), today.day.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildScreen(),
      title: 'Visit Incharge',
    );
  }

  Widget buildScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){
                  allVisits.clear();
                  datePicker();
                },
                child: Image.asset(
                  'assets/calender.png',
                  scale: 3,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '$selectedDate',
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 17,
                  color: ConstantColor.backgroundColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        allVisits.isNotEmpty
            ? Expanded(
          child: ListView.builder(
            itemCount: allVisits.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          VisitList(visitList: allVisits[index])));
                },
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundColor: ConstantColor.backgroundColor,
                  child: Icon(Icons.person),
                ),
                title: Text(
                  allVisits[index].inChargeDetail.keys.first,
                  style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      color: ConstantColor.blackColor,
                      fontSize: 17),
                ),
              );
            },
          ),
        )
            : Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/no_data.json',
                    height: 200.0),
                Text(
                  'No Visits available',
                  style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  checkVisitData(String year, String month, String day) {
    allVisits.clear();
    List<VisitViewModel> checkVisit = [];
    visitCheck.child('$year/$month/$day').once().then(
      (visit) {
        for (var check in visit.snapshot.children) {
          final data = check.value as Map<Object?, Object?>;
          final summary = data['summary'] as Map<Object?, Object?>;
          final prDetails = data['prDetails'] as Map<Object?, Object?>;
          final verification = data['verification'] as Map<Object?, Object?>;
          final productDetails =
              data['productDetails'] as Map<Object?, Object?>;
          List<Object?> crewDetails = [];
          List<Object?> crewDetailsImage = [];

          try {
            crewDetails = prDetails['supports'] as List<Object?>;
            crewDetailsImage = prDetails['supportImages'] as List<Object?>;
          } catch (e) {}

          final visitData = VisitViewModel(
            dateTime:
                DateTime(int.parse(year), int.parse(month), int.parse(day)),
            customerPhoneNumber: check.key.toString(),
            customerName: summary['customerName'].toString(),
            endKm: int.parse(verification['endKM'].toString()),
            totalKm: int.parse(verification['totalKM'].toString()),
            endKmImage: verification['endMeterReading'].toString(),
            startKm: int.parse(verification['startKM'].toString()),
            inChargeDetail: {
              prDetails['incharge'].toString():
                  prDetails['inchargeImage'].toString()
            },
            supportCrewNames: crewDetails,
            supportCrewImageLinks: crewDetailsImage,
            productImageLinks: productDetails['productImages'] as List<Object?>,
            startKmImageLink: verification['startMeterReading'].toString(),
            productName: productDetails['products'] as List<Object?>,
            quotationInvoiceNumber:
                productDetails['quotationInvoiceNumber'].toString(),
            dateOfInstallation: summary['dateOfInstallation'].toString(),
            note: summary['note'].toString(),
            visitTime: summary['visitTime'].toString(),
          );
          checkVisit.add(visitData);
        }
        setState(() {
          allVisits.addAll(checkVisit);
        });
      },
    );
  }
}
