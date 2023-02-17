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
  final List<Map<Object?, Object?>> customerInfo = [];
  List<Map<Object?, Object?>> searchCustomerInfo = [];

  late TextEditingController searchTextController;
  List<String> staffs = ['All'];
  List<String> sortList = [
    'Following Up',
    'Delayed',
    'ONWORDS',
    'Advanced',
    'Product',
    'B2B',
    'Under Construction',
    'Installation Completed',
    'Others',
  ];

  String selectedStaff = '';
  String sortOption = '';
  String query = '';
  bool isLoading = true;
  bool isAscending = false;

  //Function to fetch customer detail from firebase
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
      customerInfo.clear();
      isLoading = true;
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

    ref.child('customer').once().then((customerSnapshot) {
      for (var customer in customerSnapshot.snapshot.children) {
        final Map<Object?, Object?> data =
            customer.value as Map<Object?, Object?>;
        final createdName = createdBy == 'All' ? '' : createdBy;
        if (data['LeadIncharge']
                .toString()
                .toLowerCase()
                .contains(createdName.toLowerCase()) ||
            data['LeadIncharge']
                .toString()
                .toLowerCase()
                .contains(splitName[0].toLowerCase())) {
          if (sortOption.isNotEmpty) {
            //sorting list
            if (sortOption == 'ONWORDS') {
              if (data['customer_state']
                  .toString()
                  .toLowerCase()
                  .contains('rejected')) {
                customerInfo.add(data);
              }
            } else if (data['customer_state']
                .toString()
                .toLowerCase()
                .contains(sortChoice.toLowerCase())) {
              customerInfo.add(data);
            }
          } else {
            customerInfo.add(data);
          }
        }
      }

      //Sorting list based on created date
      if (ascending) {
        customerInfo.sort((a, b) => (a['created_date'])
            .toString()
            .compareTo(b['created_date'].toString()));
      } else {
        customerInfo.sort((a, b) => (b['created_date'])
            .toString()
            .compareTo(a['created_date'].toString()));
      }

      //For disabling loading screen
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
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
    getCustomerDetail(
        createdBy: widget.staffInfo.name,
        sortChoice: sortOption,
        ascending: isAscending);
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
        buildSearchBar(width: width, height: height),
        if (selectedStaff != '') buildFilterHint(),
        if (sortOption != '') buildSortHint(),
        Expanded(child: buildCustomerList()),
      ],
    );
  }



  Widget buildSearchBar({required double width, required double height}) {
    //search method
    void searchUser(String query) {
      final searchedCustomer = customerInfo.where((customer) {
        final nameLower = customer['name'].toString().toLowerCase();
        final phone = customer['phone_number'].toString();
        final location = customer['city'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();
        return nameLower.contains(searchQuery) ||
            phone.contains(searchQuery) ||
            location.contains(searchQuery);
      }).toList();
      setState(() {
        this.query = query;
        searchCustomerInfo = searchedCustomer;
      });
    }

    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 15.0),
      child: Row(
        children: [
          //Filter button
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

          Expanded(
            child: Container(
              height: 40.0,
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  color: ConstantColor.background1Color,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: const Color(0xffA4A1A6), width: 1.0)),
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
                  buildSortDropDown(),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Leads of $selectedStaff',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, fontSize: 13.0),
          ),
          TextButton(
            onPressed: () {
              getCustomerDetail(
                  createdBy: widget.staffInfo.name,
                  sortChoice: sortOption,
                  ascending: isAscending);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(
              'Clear',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium, fontSize: 13.0),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSortHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sorted by $sortOption',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, fontSize: 13.0),
          ),
          TextButton(
            onPressed: () {
              getCustomerDetail(
                  createdBy: selectedStaff == ''
                      ? widget.staffInfo.name
                      : selectedStaff,
                  sortChoice: '',
                  ascending: isAscending);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(
              'Clear',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium, fontSize: 13.0),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCustomerList() {
    return query == ''
        ? isLoading
            ? Center(child: Lottie.asset("assets/animation/loading.json"))
            : customerInfo.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        'Total Count :${customerInfo.length}',
                        style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                      ),
                      Expanded(
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: customerInfo.length,
                            itemBuilder: (c, index) {
                              return CustomerItem(
                                  index: index,
                                  customerInfo: customerInfo[index]);
                            }),
                      )
                    ],
                  )
                : Center(
                    child: Text(
                      'No detail found!',
                      style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          fontSize: 16.0),
                    ),
                  )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: searchCustomerInfo.length,
            itemBuilder: (c, index) {
              return CustomerItem(
                  index: index, customerInfo: searchCustomerInfo[index]);
            });
  }
}
