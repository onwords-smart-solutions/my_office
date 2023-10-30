import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_model.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../models/work_done_model.dart';
import '../util/main_template.dart';
import 'individual_work_complete.dart';

class WorkCompleteViewScreen extends StatefulWidget {
  final StaffModel userDetails;

  const WorkCompleteViewScreen({Key? key, required this.userDetails}) : super(key: key);

  @override
  State<WorkCompleteViewScreen> createState() => _WorkCompleteViewScreenState();
}

class _WorkCompleteViewScreenState extends State<WorkCompleteViewScreen> {
  final staff = FirebaseDatabase.instance.ref().child("staff");

  // notifiers
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<List<WorkDoneModel>> _workReport = ValueNotifier([]);

  @override
  void initState() {
    getWorkDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
        subtitle: 'Staff Work Details',
        templateBody: SizedBox.expand(child: buildStackWidget(height, width)),
        bgColor: ConstantColor.background1Color);
  }

  Widget buildStackWidget(double height, double width) {
    return ValueListenableBuilder(
        valueListenable: _workReport,
        builder: (ctx, workReports, child) {
          return ValueListenableBuilder(
              valueListenable: _isLoading,
              builder: (ctx, loading, child) {
                return (loading && workReports.isEmpty)
                    ? Center(child: Lottie.asset("assets/animations/new_loading.json"))
                    : Column(
                  children: [
                    if (!loading)
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton.icon(
                            onPressed: datePicker,
                            icon: const Icon(Icons.calendar_month_rounded),
                            label: ValueListenableBuilder(
                                valueListenable: _selectedDate,
                                builder: (ctx, date, child) {
                                  return Text(DateFormat('yyyy-MM-dd').format(date));
                                })),
                      ),
                    if (workReports.isEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/animations/no_data.json', height: 300.0),
                          Text(
                            'No work done submitted yet!!',
                            style: TextStyle(
                              color: ConstantColor.blackColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    else
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: ListView(
                            children: List.generate(
                              workReports.length,
                                  (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                child: ListTile(
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => IndividualWorkDone(
                                        workDetails: workReports[index],
                                      ))),
                                  tileColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                  leading: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                    clipBehavior: Clip.hardEdge,
                                    child: workReports[index].url.isEmpty
                                        ? const Image(image: AssetImage('assets/profile_icon.jpg'))
                                        : CachedNetworkImage(
                                      imageUrl: workReports[index].url,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              color: ConstantColor.backgroundColor,
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) => const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    workReports[index].name,
                                    style: TextStyle(fontFamily: ConstantFonts.sfProBold),
                                  ),
                                  subtitle: Text(
                                    workReports[index].department,
                                    style: TextStyle(fontSize: 13.0),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey.withOpacity(.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                );
              });
        });
  }

  // Functions
  datePicker() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (newDate == null) return;
    _selectedDate.value = newDate;
    getWorkDetails();
  }

  Future<void> getWorkDetails() async {
    _isLoading.value = true;
    _workReport.value.clear();
    await staff.once().then((value) async {
      if (value.snapshot.exists) {
        for (var staff in value.snapshot.children) {
          List<WorkReport> staffWorkDone = [];

          final staffInfo = staff.value as Map<Object?, Object?>;
          final uid = staff.key;
          final name = staffInfo['name'].toString();
          final dept = staffInfo['department'].toString();
          final email = staffInfo['email'].toString();
          final url = staffInfo['profileImage'] == null ? '' : staffInfo['profileImage'].toString();
          //getting work done
          final formattedMonth = DateFormat('MM').format(_selectedDate.value);
          final formattedDay = DateFormat('dd').format(_selectedDate.value);
          final fullDateFormat = '${_selectedDate.value.year}-$formattedMonth-$formattedDay';

        await FirebaseDatabase.instance.ref('workmanager/${_selectedDate.value.year}/$formattedMonth/$fullDateFormat/$uid').once().then((value) {
          if(value.snapshot.exists) {
            for (var work in value.snapshot.children) {
              final workInfo = work.value as Map<Object?, Object?>;
              final from = workInfo['from'].toString();
              final to = workInfo['to'].toString();
              final duration = workInfo['time_in_hours'].toString();
              final workDone = workInfo['workDone'].toString();
              final percentage = workInfo['workPercentage'].toString();

              staffWorkDone.add(
                WorkReport(
                  from: from,
                  to: to,
                  duration: duration,
                  workdone: workDone,
                  percentage: percentage,
                ),
              );
            }
          }
          });

            _workReport.value.add(
              WorkDoneModel(
                name: name,
                department: dept,
                url: url,
                email: email,
                reports: staffWorkDone,
              ),
            );
            _workReport.notifyListeners();
        }
      }
    });
    _isLoading.value = false;
  }
}