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
  bool isLoading = true;

  void getAllStaffDetails() async {
    employeeDetails = await allStaffDetailsCase.getStaffDetails();
    setState(() {
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
      body: employeeDetails.isEmpty
          ? Center(
              child: Lottie.asset('assets/animations/new_loading.json'),
            )
          : Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Total staffs : ${employeeDetails.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: employeeDetails.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color(0xffE0F4FF),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: employeeDetails[index].profilePic!.isEmpty
                                ? const Image(
                                    image: AssetImage(
                                      'assets/profile_icon.jpg',
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        employeeDetails[index].profilePic!,
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
                          title: Text(employeeDetails[index].name),
                          trailing: Text(employeeDetails[index].department),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => IndividualStaffDetail(
                                  allDetail: employeeDetails[index],
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
