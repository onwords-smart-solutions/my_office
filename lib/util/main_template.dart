import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Account/account_screen.dart';
import '../Constant/fonts/constant_font.dart';
import '../home/user_home_screen.dart';
import '../models/prdash_model.dart';

class MainTemplate extends StatefulWidget {
  final Widget templateBody;
  final String subtitle;
  final Color bgColor;
  final Widget? bottomImage;

  const MainTemplate(
      {Key? key,
      required this.subtitle,
      required this.templateBody,
      required this.bgColor,
      this.bottomImage})
      : super(key: key);

  @override
  State<MainTemplate> createState() => _MainTemplateState();
}

class _MainTemplateState extends State<MainTemplate> {
  final HiveOperations _hiveOperations = HiveOperations();
  StaffModel? staffInfo;

  void getStaffDetail() async {
    final data = await _hiveOperations.getStaffDetail();
    setState(() {
      staffInfo = data;
    });
  }

  SharedPreferences? preferences;

  String preferencesImageUrl = '';

  // String preferencesImageUrl2 = '';

  Future getImageUrl() async {
    preferences = await SharedPreferences.getInstance();
    // String? image = preferences?.getString('imageValue');
    String? imageNet = preferences?.getString('imageValueNet');
    if (imageNet == null) return;
    setState(() {
      // preferencesImageUrl = image.toString();
      preferencesImageUrl = imageNet;
      // print(preferencesImageUrl2);
    });
  }

  //GETTING PR DASHBOARD DETAILS FROM DB
  double prFixedAmount = 0.0;
  double prTotalAmountNumber = 0.0;
  int prTotalAmount = 0;
  List<PRDashModel> prDashInfo = [];

  Future<void> getDashboardDetails() async {
    double fixedAmount = 0.0;
    double totalAmountNumber = 0.0;
    int totalSalesNumber = 0;
    List<PRDashModel> prDash = [];
    var ref = FirebaseDatabase.instance.ref();
    await ref.child('PRDashboard/allteam').once().then((data) {
      for (var prData in data.snapshot.children) {
        final data = prData.value as Map<Object?, Object?>;

        // -- getting fixed amount --
        if (prData.key.toString() == 'fixedamount') {
          fixedAmount = double.parse(data['amount'].toString());
        } else {
          // -- adding team details into model list --
          prDash.add(PRDashModel(
              amount: double.parse(data['amount'].toString()),
              teamName: prData.key.toString(),
              sales: int.parse(data['sales'].toString())));
        }
      }
      for (var totalSales in prDash) {
        totalSalesNumber += totalSales.sales;
      }
      for (var totalAmount in prDash) {
        totalAmountNumber += totalAmount.amount;
      }
      setState(() {
        prFixedAmount = fixedAmount;
        prDashInfo = prDash;
        prTotalAmount = totalSalesNumber;
        prTotalAmountNumber = totalAmountNumber;
      });
    });
  }

  List<SalesData> getChartData() {
    List<SalesData> data = [];

    for (var team in prDashInfo) {
      if (team.teamName != 'team3') {
        String name = 'Alpha';
        if (team.teamName == 'team2') {
          name = 'Bravo';
        } else if (team.teamName == 'team4') {
          name = 'Delta';
        }

        data.add(SalesData(team.amount, name));
      }
    }
    return data;
  }

  @override
  void initState() {
    getStaffDetail();
    getImageUrl();
    getDashboardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: const Color(0xffDDE6E8),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: height * 1,
                width: width,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top * 1.1),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Name and subtitle
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              staffInfo == null
                                                  ? 'Hi'
                                                  : 'Hi ${staffInfo!.name}',
                                              style: TextStyle(
                                                  fontFamily: ConstantFonts
                                                      .sfProRegular,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            TextButton(
                                                onPressed: ()async {
                                                 await buildPRDashboard();
                                                },
                                                child: const Icon(Icons.bar_chart,color: Colors.deepPurpleAccent,)),
                                          ],
                                        ),
                                        Text(
                                          widget.subtitle,
                                          style: TextStyle(
                                              fontFamily:
                                                  ConstantFonts.sfProBold,
                                              fontSize: 15.0,
                                          color: Colors.deepPurpleAccent),
                                        ),
                                      ],
                                    ),

                                    //Profile icon
                                    GestureDetector(
                                      onTap: () {
                                        // getImageUrl();
                                        HapticFeedback.mediumImpact();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => AccountScreen(
                                                    staffDetails:
                                                        staffInfo!)));
                                      },
                                      child: SizedBox(
                                        height: height * 0.065,
                                        width: height * 0.065,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: StreamBuilder(
                                              stream: FirebaseDatabase
                                                  .instance
                                                  .ref(
                                                      'staff/${staffInfo?.uid ?? 0}')
                                                  .onValue,
                                              builder: (ctx, snapShot) {
                                                if (snapShot.hasData) {
                                                  if(snapShot.data!.snapshot.value != null){
                                                    final data = snapShot.data!
                                                        .snapshot.value
                                                    as Map<Object?,
                                                        Object?>;
                                                    final url =
                                                    data['profileImage'];
                                                    if (url != null) {
                                                      return CachedNetworkImage(
                                                        imageUrl:
                                                        url.toString(),
                                                        fit: BoxFit.cover,
                                                        progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                            CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress),
                                                        errorWidget: (context,
                                                            url, error) =>
                                                        const Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }
                                                return const Image(
                                                    image: AssetImage(
                                                        'assets/profile_icon.jpg'));
                                              },
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.001),
                      //Custom widget section
                      Expanded(child: widget.templateBody),
                    ],
                  ),
                ),
              ),
            ),
            //Illustration at the bottom
            if (widget.bottomImage != null) widget.bottomImage!,
          ],
        ),
      ),
    );
  }

  //DIALOG BOX FOR SHOWING PR DASHBOARD IN INIT STATE
  buildPRDashboard() {
    final context = this.context;
    final size = MediaQuery.sizeOf(context);
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(15),
            title: Center(
              child: Text(
                'PR Dashboard',
                style: TextStyle(
                    fontFamily: ConstantFonts.sfProBold, color: Colors.purple),
              ),
            ),
            content: Column(
              children: [
                Text(
                  'Sales Count',
                  style: TextStyle(
                    fontFamily: ConstantFonts.sfProBold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width,
                  child: ListView.builder(
                    itemCount: prDashInfo.length,
                    itemBuilder: (ctx, i) {
                      String name = 'Alpha';
                      Color color = Colors.deepPurple;

                      switch (prDashInfo[i].teamName) {
                        case 'team2':
                          name = 'Bravo';
                          color = Colors.redAccent;
                          break;
                        case 'team4':
                          name = 'Delta';
                          color = Colors.blue;
                          break;
                      }
                      return prDashInfo[i].teamName == 'team3'
                          ? const SizedBox.shrink()
                          : ListTile(
                        leading: Icon(
                          Icons.leaderboard,
                          color: color,
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontFamily: ConstantFonts.sfProMedium,
                            fontSize: 18,
                            color: color,
                          ),
                        ),
                        trailing: Text(
                          prDashInfo[i].sales.toString(),
                          style: TextStyle(
                            fontFamily: ConstantFonts.sfProMedium,
                            fontSize: 18,
                            color: color,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  height: size.height * 0.015,
                  thickness: 1,
                  color: Colors.black,
                ),
                Row(
                  children: [
                    const Spacer(flex: 3),
                    Text(
                      'Total',
                      style: TextStyle(
                          fontFamily: ConstantFonts.sfProBold, fontSize: 18),
                    ),
                    const Spacer(flex: 4),
                    Text(
                      '=',
                      style: TextStyle(
                          fontFamily: ConstantFonts.sfProBold, fontSize: 18),
                    ),
                    const Spacer(flex: 4),
                    Text(
                      '$prTotalAmount',
                      style: TextStyle(
                          fontFamily: ConstantFonts.sfProBold, fontSize: 18),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
                Divider(
                  height: size.height * 0.015,
                  thickness: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                SizedBox(
                  height: size.height * 0.4,
                  width: size.width,
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0.0,
                    primaryXAxis: CategoryAxis(
                      labelStyle: TextStyle(
                          fontFamily: ConstantFonts.sfProMedium,
                          color: Colors.black),
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                        labelStyle: TextStyle(
                            fontFamily: ConstantFonts.sfProMedium,
                            color: Colors.black),
                        majorGridLines: const MajorGridLines(width: 0)),
                    series: <ColumnSeries<SalesData, String>>[
                      ColumnSeries<SalesData, String>(
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontFamily: ConstantFonts.sfProBold,
                              color: Colors.black,
                            )),
                        dataSource: getChartData(),
                        xValueMapper: (SalesData sales, _) => sales.sales,
                        yValueMapper: (SalesData sales, _) => sales.year,
                        pointColorMapper: (SalesData sale, _) {
                          if (sale.sales == 'Alpha') {
                            return Colors.deepPurple;
                          } else if (sale.sales == 'Bravo') {
                            return Colors.redAccent;
                          }
                          return Colors.blue;
                        },
                        dataLabelMapper: (SalesData sales, _) =>
                            sales.year.toInt().toString(),
                      ),
                    ],
                    borderWidth: 0.0,
                    title: ChartTitle(
                      text: 'Sales Points',
                      textStyle: TextStyle(
                          fontFamily: ConstantFonts.sfProBold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Total  =  ${prTotalAmountNumber.toInt()}',
                    style: TextStyle(
                      fontFamily: ConstantFonts.sfProBold,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.purple.withOpacity(0.8),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: ConstantFonts.sfProBold,
                    fontSize: 17,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }
}
