import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:my_office/features/attendance/data/data_source/attendance_fb_data_source.dart';
import 'package:my_office/features/attendance/data/data_source/attendance_fb_data_source_impl.dart';
import 'package:my_office/features/attendance/data/repository/attendance_repo_impl.dart';
import 'package:my_office/features/attendance/domain/repository/attendance_repository.dart';
import 'package:my_office/features/attendance/domain/use_case/get_staff_details_use_case.dart';
import 'package:my_office/features/attendance/domain/use_case/print_screen_use_case.dart';
import 'package:my_office/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:my_office/features/auth/data/data_source/auth_fb_data_souce_impl.dart';
import 'package:my_office/features/auth/data/data_source/auth_firebase_data_source.dart';
import 'package:my_office/features/auth/data/repository/auth_repo_impl.dart';
import 'package:my_office/features/auth/domain/repository/auth_repository.dart';
import 'package:my_office/features/auth/domain/use_case/get_device_info_case.dart';
import 'package:my_office/features/auth/domain/use_case/get_fcm_tokens_case.dart';
import 'package:my_office/features/auth/domain/use_case/login_case.dart';
import 'package:my_office/features/auth/domain/use_case/remove_fcm_tokens_case.dart';
import 'package:my_office/features/auth/domain/use_case/reset_password_case.dart';
import 'package:my_office/features/auth/domain/use_case/sign_out_case.dart';
import 'package:my_office/features/auth/domain/use_case/store_fcm_tokens_case.dart';
import 'package:my_office/features/auth/presentation/provider/auth_provider.dart';
import 'package:my_office/features/create_lead/data/repository/create_lead_repo_impl.dart';
import 'package:my_office/features/create_lead/domain/repository/create_lead_repository.dart';
import 'package:my_office/features/create_lead/domain/use_case/create_lead_use_case.dart';
import 'package:my_office/features/employee_of_the_week/data/data_source/employee_fb_data_source.dart';
import 'package:my_office/features/employee_of_the_week/domain/repository/employee_repository.dart';
import 'package:my_office/features/employee_of_the_week/domain/use_case/all_staff_names_use_case.dart';
import 'package:my_office/features/employee_of_the_week/domain/use_case/update_pr_name_reason_use_case.dart';
import 'package:my_office/features/employee_of_the_week/presentation/provider/employee_of_the_week_provider.dart';
import 'package:my_office/features/home/data/repository/home_repo_impl.dart';
import 'package:my_office/features/home/domain/use_case/get_all_birthday_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_installation_members_list_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_management_list_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_punching_time_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_random_number_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_rnd_tl_list_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_staff_access_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_staff_details_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_tl_list_use_case.dart';
import 'package:my_office/features/home/domain/use_case/birthday_submit_form_use_case.dart';
import 'package:my_office/features/home/domain/use_case/phone_number_submit_form_use_case.dart';
import 'package:my_office/features/pr_dashboard/data/data_source/pr_dash_fb_data_source.dart';
import 'package:my_office/features/pr_dashboard/domain/repository/pr_dash_repository.dart';
import 'package:my_office/features/pr_dashboard/domain/use_case/pr_dashboard_details_use_case.dart';
import 'package:my_office/features/pr_dashboard/domain/use_case/update_pr_dashboard_use_case.dart';
import 'package:my_office/features/pr_dashboard/presentation/provider/pr_dash_provider.dart';
import '../../features/attendance/domain/use_case/check_time_use_case.dart';
import '../../features/attendance/domain/use_case/get_punching_time_use_case.dart';
import '../../features/auth/domain/use_case/get_staff_info_use_case.dart';
import '../../features/employee_of_the_week/data/data_source/employee_fb_data_source_impl.dart';
import '../../features/employee_of_the_week/data/repository/employee_repo_impl.dart';
import '../../features/home/data/data_source/home_fb_data_source.dart';
import '../../features/home/data/data_source/home_fb_data_source_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../../features/home/presentation/provider/home_provider.dart';
import '../../features/pr_dashboard/data/data_source/pr_dash_fb_data_source_impl.dart';
import '../../features/pr_dashboard/data/repository/pr_dash_repo_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PROVIDERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

  ///AUTH PROVIDER
  sl.registerFactory<AuthProvider>(
    () => AuthProvider(
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
    ),
  );

  ///HOME PROVIDER
  sl.registerFactory<HomeProvider>(
        () => HomeProvider(
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
      sl.call(),
    ),
  );

  ///ATTENDANCE PROVIDER
  sl.registerFactory<AttendanceProvider>(
          () => AttendanceProvider(
        sl.call(),
        sl.call(),
        sl.call(),
        sl.call(),
      ),
  );

  ///EMPLOYEE OF THE WEEK PROVIDER
  sl.registerFactory<EmployeeProvider>(
        () => EmployeeProvider(
      sl.call(),
      sl.call(),
    ),
  );

  ///PR DASHBOARD PROVIDER
  sl.registerFactory<PrDashProvider>(
        () => PrDashProvider(
      sl.call(),
      sl.call(),
    ),
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ USE CASES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
  ///LOGIN
  sl.registerLazySingleton<LoginCase>(
    () => LoginCase(authRepository: sl.call()),
  );

  ///RESET PASSWORD
  sl.registerLazySingleton<ResetPasswordCase>(
    () => ResetPasswordCase(authRepository: sl.call()),
  );

  ///GET DEVICE INFO
  sl.registerLazySingleton<GetDeviceInfoCase>(
    () => GetDeviceInfoCase(authRepository: sl.call()),
  );

  ///GET FCM TOKENS
  sl.registerLazySingleton<GetFcmTokensCase>(
    () => GetFcmTokensCase(authRepository: sl.call()),
  );

  ///REMOVE FCM TOKEN
  sl.registerLazySingleton<RemoveFcmCase>(
    () => RemoveFcmCase(authRepository: sl.call()),
  );

  ///SIGN OUT
  sl.registerLazySingleton<SignOutCase>(
    () => SignOutCase(authRepository: sl.call()),
  );

  ///STORE FCM TOKENS
  sl.registerLazySingleton<StoreFcmCase>(
    () => StoreFcmCase(authRepository: sl.call()),
  );

  ///GET ALL BIRTHDAYS
  sl.registerLazySingleton<GetAllBirthdayCase>(
        () => GetAllBirthdayCase(homeRepository: sl.call()),
  );

  ///GET INSTALLATION NAMES
  sl.registerLazySingleton<GetInstallationMembersListCase>(
        () => GetInstallationMembersListCase(homeRepository: sl.call()),
  );

  ///GET MANAGEMENT NAMES
  sl.registerLazySingleton<GetManagementListCase>(
        () => GetManagementListCase(homeRepository: sl.call()),
  );

  ///GET PUNCHING TIME
  sl.registerLazySingleton<GetPunchingTimeCase>(
        () => GetPunchingTimeCase(homeRepository: sl.call()),
  );

  ///GET RANDOM NUMBER
  sl.registerLazySingleton<GetRandomNumberCase>(
        () => GetRandomNumberCase(homeRepository: sl.call()),
  );

  ///GET RND TL NAMES
  sl.registerLazySingleton<GetRndTlListCase>(
        () => GetRndTlListCase(homeRepository: sl.call()),
  );

  ///GET STAFF ACCESS
  sl.registerLazySingleton<GetStaffAccessCase>(
        () => GetStaffAccessCase(homeRepository: sl.call()),
  );

  ///GET STAFF DETAILS
  sl.registerLazySingleton<GetStaffDetailsCase>(
        () => GetStaffDetailsCase(homeRepository: sl.call()),
  );

  ///GET TL NAMES
  sl.registerLazySingleton<GetTlListCase>(
        () => GetTlListCase(homeRepository: sl.call()),
  );

  ///BIRTHDAY SUBMIT FORM
  sl.registerLazySingleton<BirthdaySubmitFormCase>(
        () => BirthdaySubmitFormCase(homeRepository: sl.call()),
  );

  ///PHONE NUMBER SUBMIT FORM
  sl.registerLazySingleton<PhoneNumberSubmitFormCase>(
      () => PhoneNumberSubmitFormCase(homeRepository: sl.call()),
  );

  ///GET EMPLOYEE INFO
  sl.registerLazySingleton<GetStaffInfoCase>(
        () => GetStaffInfoCase(authRepository: sl.call()),
  );

  ///CHECK ATTENDANCE TIME
  sl.registerLazySingleton<CheckTimeCase>(
        () => CheckTimeCase(attendanceRepository: sl.call()),
  );

  ///GET ATTENDANCE PUNCHING TIME
  sl.registerLazySingleton<GetPunchTimeCase>(
        () => GetPunchTimeCase(attendanceRepository: sl.call()),
  );

  ///GET STAFF DETAILS
  sl.registerLazySingleton<GetAllStaffDetailsCase>(
        () => GetAllStaffDetailsCase(attendanceRepository: sl.call()),
  );

  ///PRINT SCREEN
  sl.registerLazySingleton<PrintScreenCase>(
        () => PrintScreenCase(attendanceRepository: sl.call()),
  );

  ///ALL STAFF NAMES
  sl.registerLazySingleton<AllStaffNamesCase>(
        () => AllStaffNamesCase(employeeRepository: sl.call()),
  );

  ///UPDATE PR NAME REASON
  sl.registerLazySingleton<UpdatePrNameReasonCase>(
        () => UpdatePrNameReasonCase(employeeRepository: sl.call()),
  );

  ///PR DASHBOARD DETAILS
  sl.registerLazySingleton<PrDashboardUseCase>(
        () => PrDashboardUseCase(prDashRepository: sl.call()),
  );

  ///UPDATE PR DASHBOARD DETAILS
  sl.registerLazySingleton<UpdatePrDashboardCase>(
        () => UpdatePrDashboardCase(prDashRepository: sl.call()),
  );

  ///CREATE LEAD
  sl.registerLazySingleton<CreateLeadCase>(
        () => CreateLeadCase(createLeadRepository: sl.call()),
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ REPOSITORIES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

  ///AUTH
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepoImpl(sl.call()),
  );

  ///HOME SCREEN
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepoImpl(sl.call()),
  );

  ///ATTENDANCE SCREEN
  sl.registerLazySingleton<AttendanceRepository>(
        () => AttendanceRepoImpl(sl.call()),
  );

  ///EMPLOYEE OF THE WEEK SCREEN
  sl.registerLazySingleton<EmployeeRepository>(
        () => EmployeeRepoImpl(sl.call()),
  );

  ///PR DASHBOARD DETAILS SCREEN
  sl.registerLazySingleton<PrDashRepository>(
        () => PrDashRepoImpl(sl.call()),
  );

  ///CREATE LEAD SCREEN
  sl.registerLazySingleton<CreateLeadRepository>(
        () => CreateLeadRepoImpl(),
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DATA SOURCE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

  ///AUTH
  sl.registerLazySingleton<AuthFbDataSource>(
      () => AuthFbDataSourceImpl(sl.call(), sl.call()),
  );

  ///HOME SCREEN
  sl.registerLazySingleton<HomeFbDataSource>(
        () => HomeFbDataSourceImpl(),
  );

  ///ATTENDANCE SCREEN
  sl.registerLazySingleton<AttendanceFbDataSource>(
        () => AttendanceFbDataSourceImpl(),
  );

  ///EMPLOYEE OF THE WEEK SCREEN
  sl.registerLazySingleton<EmployeeFbDataSource>(
        () => EmployeeFbDataSourceImpl(),
  );

  ///PR DASHBOARD DETAILS SCREEN
  sl.registerLazySingleton<PrDashFbDataSource>(
        () => PrDashFbDataSourceImpl(sl.call()),
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EXTERNAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
  final fbDb = FirebaseDatabase.instance;
  final fbAuth = FirebaseAuth.instance;

  sl.registerLazySingleton<FirebaseAuth>(() => fbAuth);
  sl.registerLazySingleton<FirebaseDatabase>(() => fbDb);
}
