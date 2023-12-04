import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/hr_access/data/data_source/hr_access_fb_data_source.dart';
import 'package:my_office/features/hr_access/data/data_source/hr_access_fb_data_source_impl.dart';
import 'package:my_office/features/hr_access/data/repository/hr_access_repo_impl.dart';
import 'package:my_office/features/hr_access/domain/repository/hr_access_repository.dart';
import 'package:my_office/features/hr_access/domain/use_case/all_staff_details_use_case.dart';
import 'package:my_office/features/hr_access/presentation/view/individual_staff_details.dart';

import '../../data/model/hr_access_staff_model.dart';

class AllStaffs extends StatefulWidget {
  const AllStaffs({super.key});

  @override
  State<AllStaffs> createState() => _AllStaffsState();
}

class _AllStaffsState extends State<AllStaffs> {
  late HrAccessFbDataSource hrAccessFbDataSource = HrAccessFbDataSourceImpl();
  late HrAccessRepository hrAccessRepository =
      HrAccessRepoImpl(hrAccessFbDataSource);
  late AllStaffDetailsCase allStaffDetailsCase =
      AllStaffDetailsCase(hrAccessRepository: hrAccessRepository);
  List<HrAccessModel> employeeDetails = [];
  List<HrAccessModel> sortEmployees = [];
  final List<String> dep = [
    'ALL',
    'APP',
    'WEB',
    'MEDIA',
    'RND',
    'INSTALLATION',
    'PR',
    'HR',
    'MANAGEMENT',
    'OFFICE STAFF',
  ];
  bool isLoading = false;
  String department = 'ALL';

  void getAllStaffDetails() async {
    sortEmployees.clear();
    employeeDetails.clear();
    setState(() {
      isLoading = true;
    });
    var allDetails = await allStaffDetailsCase.getStaffDetails();
    if (!mounted) return;
    setState(() {
      employeeDetails = allDetails;
      sortEmployees = employeeDetails;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllStaffDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.chevron_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Employee details',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: Lottie.asset('assets/animations/new_loading.json'),
            )
          : Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Total staffs : ${sortEmployees.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          position: PopupMenuPosition.under,
                          elevation: 10,
                          itemBuilder: (ctx) => List.generate(
                            dep.length,
                            (i) {
                              return PopupMenuItem(
                                child: Text(
                                  dep[i],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    department = dep[i];
                                    if (department == 'ALL') {
                                      sortEmployees = employeeDetails;
                                    } else {
                                      sortEmployees = employeeDetails
                                          .where((element) =>
                                              element.department == department,
                                      )
                                          .toList();
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.sort_down),
                              Text(
                                department,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortEmployees.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 5,
                        color: Colors.white,
                        child: ListTile(
                          leading: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: sortEmployees[index].profilePic!.isEmpty
                                ? const Image(
                                    image: AssetImage(
                                      'assets/profile_icon.jpg',
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                    sortEmployees[index].profilePic!,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (
                                      context,
                                      url,
                                      downloadProgress,
                                    ) =>
                                        CircularProgressIndicator(
                                      color: AppColor.primaryColor,
                                      value: downloadProgress.progress,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                          ),
                          title: Text(sortEmployees[index].name),
                          trailing: Text(sortEmployees[index].department),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => IndividualStaffDetail(
                                  allDetail: sortEmployees[index],
                                  allStaffData: sortEmployees,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
