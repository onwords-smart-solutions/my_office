import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/util/main_template.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../PR/customer_item.dart';

class SearchLeadsScreen extends StatefulWidget {
  final StaffModel staffInfo;

  const SearchLeadsScreen({Key? key, required this.staffInfo})
      : super(key: key);

  @override
  State<SearchLeadsScreen> createState() => _SearchLeadsScreenState();
}

class _SearchLeadsScreenState extends State<SearchLeadsScreen> {
  final ref = FirebaseDatabase.instance.ref();
  late TextEditingController searchTextController;
  List<Map<Object?, Object?>> allCustomer = [];
  List<Map<Object?, Object?>> currentCustomerList = [];
  List<Map<Object?, Object?>> searchCustomerInfo = [];

  List<String> staffs = ['All', 'Not Assigned'];
  List<String> sortList = [
    'Following Up',
    'Delayed',
    'Onwords',
    'Advanced',
    'Product',
    'B2B',
    'Under Construction',
    'Installation Completed',
    'Others',
    'Hot lead',
    'Black dots'
  ];

  String selectedStaff = '';
  String sortOption = '';
  String query = '';
  bool isLoading = true;
  bool isAscending = false;

  //Function to fetch customer detail from firebase
  void getCustomerFromFirebase() {
    allCustomer.clear();
    ref.child('customer').once().then((customerSnapshot) {
      for (var customer in customerSnapshot.snapshot.children) {
        final Map<Object?, Object?> data =
            customer.value as Map<Object?, Object?>;
        allCustomer.add(data);
      }

      getCustomerDetail(
          createdBy:
              selectedStaff == '' ? widget.staffInfo.name : selectedStaff,
          sortChoice: sortOption,
          ascending: isAscending);
      //For disabling loading screen
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  void getCustomerDetail(
      {required String createdBy,
      required String sortChoice,
      required bool ascending}) {

    bool isSame = false;
    if (createdBy.toLowerCase() ==
        widget.staffInfo.name.toString().toLowerCase()) {
      isSame = true;
    }
    //For enabling loading screen
    if (!mounted) return;
    setState(() {
      currentCustomerList.clear();
      selectedStaff = isSame ? '' : createdBy;
      sortOption = sortChoice;
      if (ascending) {
        isAscending = true;
      } else {
        isAscending = false;
      }
    });

    //Splitting name to get first name
    final splitName = createdBy.split(' ');

    for (var customer in allCustomer) {
      final Map<Object?, Object?> data = customer;
      final createdName = createdBy == 'All' ? '' : createdBy;
      if (data['LeadIncharge']
              .toString()
              .toLowerCase()
              .contains(createdName.toLowerCase()) ||
          data['LeadIncharge']
              .toString()
              .toLowerCase()
              .contains(createdBy.toLowerCase())) {
        if (sortOption.isNotEmpty) {
          //sorting list
          if (sortOption == 'Onwords') {
            if (data['customer_state']
                .toString()
                .toLowerCase()
                .contains('rejected')  ||
                data['customer_state']
                .toString()
                .toLowerCase()
                .contains('onwords') ||
                data['customer_state']
                    .toString()
                    .toLowerCase()
                    .contains('rejected from mgmt') ||
                data['customer_state']
                    .toString()
                    .toLowerCase()
                    .contains('rejected from customer') ) {
              currentCustomerList.add(data);
            }
          }else if(sortOption == 'Black dots'){
          try{
            //Getting all notes from customer data
            final Map<Object?, Object?> allNotes =
            data['notes'] as Map<Object?, Object?>;
            final noteKeys = allNotes.keys.toList();

            //Checking if key is empty or not
            if (noteKeys.isNotEmpty) {
              noteKeys.sort((a, b) => b.toString().compareTo(a.toString()));
              final Map<Object?, Object?> firstNote =
              allNotes[noteKeys[0]] as Map<Object?, Object?>;
              final lastNoteDate = firstNote['date'].toString();
              final lastNoteUpdatedOn = DateTime.parse(lastNoteDate);
              print('date is $lastNoteUpdatedOn');
              if (calculateDifference(lastNoteUpdatedOn) <= -7) {
                currentCustomerList.add(data);
              }
            }
          }catch(e){
            print('error is $e');
          }
          }
          else if (data['customer_state']
              .toString()
              .toLowerCase()
              .contains(sortChoice.toLowerCase())) {
            currentCustomerList.add(data);
          }
        }else {
          currentCustomerList.add(data);
        }
      }
    }


    //Sorting list based on created date
    if (ascending) {
      currentCustomerList.sort((a, b) => (a['created_date'])
          .toString()
          .compareTo(b['created_date'].toString()));
    } else {
      currentCustomerList.sort((a, b) => (b['created_date'])
          .toString()
          .compareTo(a['created_date'].toString()));
    }

    //For disabling loading screen
    if (!mounted) return;
    setState(() {});
  }

  //Fetching PR Staff Names from firebase database
  void getPRStaffNames() {
    ref.child('staff').once().then((staffSnapshot) {
      for (var data in staffSnapshot.snapshot.children) {
        var fbData = data.value as Map<Object?, Object?>;
        if (fbData['department'] == 'PR') {
          final name = fbData['name'].toString();
          staffs.add(name);
        }
      }

      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void initState() {
    searchTextController = TextEditingController();
    getCustomerFromFirebase();
    getPRStaffNames();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Search leads here!',
        templateBody: buildScreen(),
        bgColor: ConstantColor.background1Color);
  }

  Widget buildScreen() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        buildSearchBar(width: width),
        Container(
            height: height * .05,
            width: width,
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: buildSortHint()),
        if (selectedStaff != '') buildFilterHint(),
        Expanded(child: buildCustomerList()),
      ],
    );
  }

  Widget buildSearchBar({required double width}) {
    //search method
    void searchUser(String query) {
      final searchedCustomer = currentCustomerList.where((customer) {
        final nameLower = customer['name'].toString().toLowerCase();
        final phone = customer['phone_number'].toString();
        final location = customer['city'].toString().toLowerCase();
        final id = customer['customer_id'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();
        return nameLower.contains(searchQuery) ||
            phone.contains(searchQuery) ||
            location.contains(searchQuery) ||
        id == searchQuery;
      }).toList();
      setState(() {
        this.query = query;
        searchCustomerInfo = searchedCustomer;
      });
    }

    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 10.0),
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
            color: ConstantColor.background1Color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xffA4A1A6), width: 1.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Search bar
            Expanded(
              child: CupertinoSearchTextField(
                backgroundColor: const Color(0xffF1F2F8),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                prefixIcon: Image.asset(
                  'assets/search.png',
                  scale: 4.5,
                ),
                controller: searchTextController,
                placeholder: 'Search leads',
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  searchUser(value.toString());
                },
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 15,
                    color: Colors.black),
              ),
            ),
            const VerticalDivider(
              thickness: 1,
              indent: 5.0,
              endIndent: 5.0,
              color: Color(0xffA4A1A6),
            ),
            buildDropDown(),

            IconButton(
              onPressed: () {
                getCustomerDetail(
                    createdBy: selectedStaff == ''
                        ? widget.staffInfo.name
                        : selectedStaff,
                    sortChoice: sortOption,
                    ascending: !isAscending);
              },
              icon: Icon(
                isAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 20.0,
              ),
              color: const Color(0xffB13FC8),
            ),
            // buildSortDropDown(),
          ],
        ),
      ),
    );
  }

  Widget buildDropDown() {
    return PopupMenuButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        position: PopupMenuPosition.under,
        elevation: 10.0,
        itemBuilder: (ctx) => List.generate(
              staffs.length,
              (index) {
                if (staffs[index] == 'All') {
                  return PopupMenuItem(
                    child: Text(
                      staffs[index],
                      style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
                    ),
                    onTap: () {
                      getCustomerDetail(
                          createdBy: 'All',
                          sortChoice: sortOption,
                          ascending: isAscending);
                    },
                  );
                }
                return PopupMenuItem(
                  child: Text(
                    staffs[index],
                    style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
                  ),
                  onTap: () {
                    getCustomerDetail(
                        createdBy: staffs[index],
                        sortChoice: sortOption,
                        ascending: isAscending);
                  },
                );
              },
            ),
        icon: Image.asset(
          'assets/filter.png',
          scale: 4.5,
        ));
  }

  Widget buildSortDropDown() {
    return PopupMenuButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        position: PopupMenuPosition.under,
        elevation: 10.0,
        itemBuilder: (ctx) => List.generate(
              sortList.length,
              (index) {
                return PopupMenuItem(
                  child: Text(
                    sortList[index],
                    style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
                  ),
                  onTap: () {
                    getCustomerDetail(
                        createdBy: selectedStaff == ''
                            ? widget.staffInfo.name
                            : selectedStaff,
                        sortChoice: sortList[index],
                        ascending: isAscending);
                  },
                );
              },
            ),
        icon: const Icon(
          Icons.filter_list_rounded,
          color: Color(0xffB93DCB),
          size: 25.0,
        ));
  }

  Widget buildFilterHint() {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 5.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),

            decoration: BoxDecoration(
              color: const Color(0xff8355B7),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Text(
              'Leads of $selectedStaff',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium, fontSize: 14.0,color: Color(0xffF1F2F8)),
            ),
          ),
          IconButton(
            onPressed: () {
              getCustomerDetail(
                  createdBy: widget.staffInfo.name,
                  sortChoice: sortOption,
                  ascending: isAscending);
            },
            icon: const Icon(Icons.cancel,size: 20.0,),

            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget buildSortHint() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sortList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (ctx, i) {
          Color containerColor = sortOption == sortList[i]
              ? const Color(0xff8355B7)
              : const Color(0xffF1F2F8);
          Color textColor = sortOption == sortList[i]
              ? Colors.white
              : const Color(0xff8355B7);

          return GestureDetector(
            onTap: () {
              getCustomerDetail(
                  createdBy: selectedStaff == ''
                      ? widget.staffInfo.name
                      : selectedStaff,
                  sortChoice: sortOption == sortList[i] ? '' : sortList[i],
                  ascending: isAscending);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(50.0),
                  border:
                      Border.all(width: 1.0, color: const Color(0xff8355B7))),
              child: Center(
                child: Text(
                  sortList[i],
                  style: TextStyle(
                      fontFamily: ConstantFonts.poppinsBold,
                      fontSize: 10.0,
                      color: textColor),
                ),
              ),
            ),
          );
        });
  }

  Widget buildCustomerList() {
    return query == ''
        ? isLoading
            ? Center(child: Lottie.asset("assets/animations/new_loading.json"))
            : currentCustomerList.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        'Total Count :${currentCustomerList.length}',
                        style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                      ),
                      Expanded(
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: currentCustomerList.length,
                            itemBuilder: (c, index) {
                              return CustomerItem(
                                  customerInfo: currentCustomerList[index], currentStaffName: widget.staffInfo.name,);
                            }),
                      )
                    ],
                  )
                : Center(
                    child: Text(
                      'No leads found!',
                      style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          fontSize: 16.0),
                    ),
                  )
        : searchCustomerInfo.isNotEmpty? ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: searchCustomerInfo.length,
            itemBuilder: (c, index) {
              return CustomerItem(
                  customerInfo: searchCustomerInfo[index], currentStaffName: widget.staffInfo.name,);
            }):Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text('No result for $query',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),),
            );
  }
}
