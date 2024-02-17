import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/search_leads/data/data_source/search_leads_fb_data_source.dart';
import 'package:my_office/features/search_leads/data/data_source/search_leads_fb_data_source_impl.dart';
import 'package:my_office/features/search_leads/data/repository/search_leads_repo_impl.dart';
import 'package:my_office/features/search_leads/domain/repository/search_leads_repository.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import '../view_model/customer_lead_item_details.dart';

class SearchLeadsScreen extends StatefulWidget {
  final UserEntity staffInfo;
  final String? query;
  final String? selectedStaff;

  const SearchLeadsScreen({
    Key? key,
    required this.staffInfo,
    this.query,
    this.selectedStaff,
  }) : super(key: key);

  @override
  State<SearchLeadsScreen> createState() => _SearchLeadsScreenState();
}

class _SearchLeadsScreenState extends State<SearchLeadsScreen> {
  late TextEditingController searchTextController;
  List<Map<Object?, Object?>> allCustomer = [];
  List<Map<Object?, Object?>> currentCustomerList = [];
  List<Map<Object?, Object?>> searchCustomerInfo = [];
  final List<Map<Object?, Object?>> _selectedCustomers = [];

  bool isLeadChange = false;
  bool isSelectAll = false;
  bool isDataLoading = false;
  bool isLoading = true;

  late SearchLeadsFbDataSource searchLeadsFbDataSource =
      SearchLeadsFbDataSourceImpl();
  late SearchLeadsRepository searchLeadsRepository =
      SearchLeadsRepoImpl(searchLeadsFbDataSource);

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

  List<String> staffs = ['All', 'Not Assigned'];
  List<String> sortList = [
    'New leads',
    'Following Up',
    'Delayed',
    'Onwords',
    'Advanced',
    'Product',
    'B2B',
    'Under Construction',
    'Installation Completed',
    'Others',
    'Interested',
    'Visited',
    'Need to visit',
    'Quotation',
    'Black dots',
  ];

  String selectedStaff = '';
  String sortOption = '';
  String query = '';
  bool isAscending = false;

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  // SORTING CUSTOMER DETAILS
  void getCustomerDetail({
    required String createdBy,
    required String sortChoice,
    required bool ascending,
  }) {
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
                    .contains('rejected') ||
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
                    .contains('rejected from customer')) {
              currentCustomerList.add(data);
            }
          } else if (sortOption == 'Interested') {
            if (data['customer_state']
                    .toString()
                    .toLowerCase()
                    .contains('hot lead') ||
                (data['customer_state']
                    .toString()
                    .toLowerCase()
                    .contains('interested'))) {
              currentCustomerList.add(data);
            }
          } else if (sortOption == 'New leads') {
            if (data['notes'].toString().toLowerCase() == 'null' ||
                data['customer_state']
                    .toString()
                    .toLowerCase()
                    .contains('new leads')) {
              currentCustomerList.add(data);
            }
          } else if (sortOption == 'Black dots') {
            try {
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
            } catch (e) {
              print('error is $e');
            }
          } else if (data['customer_state']
              .toString()
              .toLowerCase()
              .contains(sortChoice.toLowerCase())) {
            currentCustomerList.add(data);
          }
        } else {
          currentCustomerList.add(data);
        }
      }
    }

    //Sorting list based on created date
    if (ascending) {
      currentCustomerList.sort(
        (a, b) => (a['created_date'])
            .toString()
            .compareTo(b['created_date'].toString()),
      );
    } else {
      currentCustomerList.sort(
        (a, b) => (b['created_date'])
            .toString()
            .compareTo(a['created_date'].toString()),
      );
    }

    //For disabling loading screen
    if (!mounted) return;
    setState(() {});
  }

  // PR STAFF NAMES & CUSTOMER DETAILS FETCHING AND ASSIGNING
  void fetchInitialData() async {
    try {
      allCustomer = await searchLeadsRepository.getCustomers();
      getCustomerDetail(
        createdBy: widget.selectedStaff != null
            ? widget.selectedStaff!
            : selectedStaff == ''
                ? widget.staffInfo.name
                : selectedStaff,
        sortChoice: sortOption,
        ascending: isAscending,
      );
      var fetchedPRStaffNames = await searchLeadsRepository.getPRStaffNames();
      setState(() {
        staffs = fetchedPRStaffNames;
        isLoading = false;
      });
      if (widget.query != null) {
        searchUser(widget.query!);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    searchTextController = TextEditingController();
    fetchInitialData();
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
      subtitle: 'Search leads',
      templateBody: buildScreen(),
      bgColor: AppColor.backGroundColor,
    );
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
          child: buildSortHint(),
        ),
        if (selectedStaff != '') buildFilterHint(),
        Expanded(
          child: buildCustomerList(),
        ),
      ],
    );
  }

  Widget buildSearchBar({required double width}) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 10.0),
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(.3),
              width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Search bar
            Expanded(
              child: CupertinoSearchTextField(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                itemColor: Theme.of(context).primaryColor.withOpacity(.4),
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
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            VerticalDivider(
              thickness: 1,
              indent: 5.0,
              endIndent: 5.0,
              color: Theme.of(context).primaryColor.withOpacity(.4),
            ),
            widget.staffInfo.uid == 'ajckJI82Y4Uk6780vpSMmyo3ylr2' ?
                const SizedBox.shrink() :
            buildDropDown(),

            IconButton(
              onPressed: () {
                getCustomerDetail(
                  createdBy: selectedStaff == ''
                      ? widget.staffInfo.name
                      : selectedStaff,
                  sortChoice: sortOption,
                  ascending: !isAscending,
                );
              },
              icon: Icon(
                isAscending
                    ? CupertinoIcons.up_arrow
                    : CupertinoIcons.down_arrow,
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
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      position: PopupMenuPosition.under,
      elevation: 10.0,
      itemBuilder: (ctx) => List.generate(
        staffs.length,
        (index) {
          if (staffs[index] == 'All') {
            return PopupMenuItem(
              child: Text(
                staffs[index],
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onTap: () {
                getCustomerDetail(
                  createdBy: 'All',
                  sortChoice: sortOption,
                  ascending: isAscending,
                );
              },
            );
          }
          return PopupMenuItem(
            child: Text(
              staffs[index],
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              getCustomerDetail(
                createdBy: staffs[index],
                sortChoice: sortOption,
                ascending: isAscending,
              );
            },
          );
        },
      ),
      icon: Image.asset(
        'assets/filter.png',
        scale: 4.5,
      ),
    );
  }

  Widget buildSortDropDown() {
    return PopupMenuButton(
      surfaceTintColor: Colors.transparent,
      color: Theme.of(context).primaryColor.withOpacity(.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      position: PopupMenuPosition.under,
      elevation: 10.0,
      itemBuilder: (ctx) => List.generate(
        sortList.length,
        (index) {
          return PopupMenuItem(
            child: Text(
              sortList[index],
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              getCustomerDetail(
                createdBy:
                    selectedStaff == '' ? widget.staffInfo.name : selectedStaff,
                sortChoice: sortList[index],
                ascending: isAscending,
              );
            },
          );
        },
      ),
      icon: const Icon(
        Icons.filter_list_rounded,
        color: Color(0xffB93DCB),
        size: 25.0,
      ),
    );
  }

  Widget buildFilterHint() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: const Color(0xff8355B7),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                'Leads of $selectedStaff',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              getCustomerDetail(
                createdBy: widget.staffInfo.name,
                sortChoice: sortOption,
                ascending: isAscending,
              );
            },
            icon: const Icon(
              CupertinoIcons.xmark_octagon_fill,
              size: 22.0,
            ),
            color: Colors.red,
          ),
          if (isLeadChange)
            isDataLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Row(
                    children: [
                      Text(
                        _selectedCustomers.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Checkbox(
                        value: isSelectAll,
                        onChanged: (value) {
                          setState(() {
                            isSelectAll = value ?? false;
                          });
                          if (isSelectAll) {
                            _selectedCustomers.clear();
                            _selectedCustomers.addAll(currentCustomerList);
                          } else {
                            _selectedCustomers.clear();
                          }
                        },
                      ),
                      PopupMenuButton(
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        position: PopupMenuPosition.under,
                        elevation: 10.0,
                        itemBuilder: (ctx) => List.generate(
                          staffs.length,
                          (index) {
                            return PopupMenuItem(
                              child: Text(
                                staffs[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onTap: () => changeLead(staffs[index]),
                            );
                          },
                        ),
                        icon: const Icon(
                          Icons.settings_accessibility_rounded,
                          color: Color(0xffB93DCB),
                          size: 25.0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedCustomers.clear();
                            isLeadChange = false;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
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
            : Theme.of(context).scaffoldBackgroundColor;
        Color textColor = sortOption == sortList[i]
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor;

        return GestureDetector(
          onTap: () {
            getCustomerDetail(
              createdBy:
                  selectedStaff == '' ? widget.staffInfo.name : selectedStaff,
              sortChoice: sortOption == sortList[i] ? '' : sortList[i],
              ascending: isAscending,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(
                  width: 1.0,
                  color: Theme.of(context).primaryColor.withOpacity(.2)),
            ),
            child: Center(
              child: Text(
                sortList[i],
                style: TextStyle(
                  fontSize: 13.0,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCustomerList() {
    return query == ''
        ? isLoading
            ? Center(
                child: Theme.of(context).scaffoldBackgroundColor ==
                        const Color(0xFF1F1F1F)
                    ? Lottie.asset('assets/animations/loading_light_theme.json')
                    : Lottie.asset('assets/animations/loading_dark_theme.json'),
              )
            : currentCustomerList.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        'Total Count :${currentCustomerList.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Scrollbar(
                          thickness: 7,
                          radius: const Radius.circular(12),
                          thumbVisibility: true,
                          interactive: true,
                          child: ListView.builder(
                            itemCount: currentCustomerList.length,
                            itemBuilder: (c, index) {
                              return GestureDetector(
                                onTap: isLeadChange
                                    ? () {
                                        addOrRemoveCustomer(
                                          currentCustomerList[index],
                                        );
                                      }
                                    : null,
                                onLongPress: () {
                                  if (widget.staffInfo.name == 'Anitha' ||
                                      widget.staffInfo.name == 'Devendiran' ||
                                      widget.staffInfo.name == 'Rajkannan B' ||
                                      widget.staffInfo.name == 'Logesh P') {
                                    setState(() {
                                      isLeadChange = true;
                                    });
                                  } else {
                                    setState(() {
                                      isLeadChange = false;
                                    });
                                  }
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected(currentCustomerList[index])
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.5)
                                            : null,
                                  ),
                                  child: Opacity(
                                    opacity:
                                        isSelected(currentCustomerList[index])
                                            ? .7
                                            : 1,
                                    child: CustomerItem(
                                      isLeadChange: isLeadChange,
                                      customerInfo: currentCustomerList[index],
                                      currentStaffName: widget.staffInfo.name,
                                      prNames: staffs,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      'No leads found!!',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
        : searchCustomerInfo.isNotEmpty
            ? ListView.builder(
                itemCount: searchCustomerInfo.length,
                itemBuilder: (c, index) {
                  return CustomerItem(
                    isLeadChange: isLeadChange,
                    customerInfo: searchCustomerInfo[index],
                    currentStaffName: widget.staffInfo.name,
                    prNames: staffs,
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'No result for $query',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
  }

  // ******************* LEAD CHANGE FUNCTIONS ************************
  void addOrRemoveCustomer(Map<Object?, Object?> customer) {
    setState(() {
      if (_selectedCustomers.contains(customer)) {
        _selectedCustomers.remove(customer);
      } else {
        _selectedCustomers.add(customer);
      }
    });
  }

  bool isSelected(Map<Object?, Object?> customer) =>
      _selectedCustomers.contains(customer);

  changeLead(String staff) async {
    setState(() {
      isDataLoading = true;
    });

    for (var customer in _selectedCustomers) {
      //UPDATING LEAD CHANGE IN FIREBASE
      await searchLeadsRepository.updateCustomerLead(
        customer['phone_number'].toString(),
        staff,
      );

      final index = allCustomer.indexWhere(
        (element) => element['phone_number'] == customer['phone_number'],
      );
      final cIndex = currentCustomerList.indexWhere(
        (element) => element['phone_number'] == customer['phone_number'],
      );
      if (index > -1) {
        allCustomer[index]['LeadIncharge'] = staff;
      }
      if (cIndex > -1) {
        currentCustomerList[cIndex]['LeadIncharge'] = staff;
      }
    }
    setState(() {
      _selectedCustomers.clear();
      isLeadChange = false;
      isSelectAll = false;
      isDataLoading = false;
    });
  }
}
