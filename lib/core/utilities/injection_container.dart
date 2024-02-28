import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:my_office/features/attendance/data/data_source/attendance_fb_data_source.dart';
import 'package:my_office/features/attendance/data/data_source/attendance_fb_data_source_impl.dart';
import 'package:my_office/features/attendance/data/repository/attendance_repo_impl.dart';
import 'package:my_office/features/attendance/domain/repository/attendance_repository.dart';
import 'package:my_office/features/auth/data/data_source/auth_fb_data_souce_impl.dart';
import 'package:my_office/features/auth/data/data_source/auth_fb_data_source.dart';
import 'package:my_office/features/auth/data/data_source/auth_local_data_source.dart';
import 'package:my_office/features/auth/data/repository/auth_repo_impl.dart';
import 'package:my_office/features/auth/domain/repository/auth_repository.dart';
import 'package:my_office/features/auth/domain/use_case/reset_password_case.dart';
import 'package:my_office/features/auth/presentation/provider/authentication_provider.dart';
import 'package:my_office/features/create_lead/data/data_source/create_lead_fb_data_source.dart';
import 'package:my_office/features/create_lead/data/data_source/create_lead_fb_data_source_impl.dart';
import 'package:my_office/features/create_lead/data/repository/create_lead_repo_impl.dart';
import 'package:my_office/features/create_lead/domain/repository/create_lead_repository.dart';
import 'package:my_office/features/create_lead/domain/use_case/create_lead_use_case.dart';
import 'package:my_office/features/create_lead/presentation/provider/create_lead_provider.dart';
import 'package:my_office/features/create_product/data/repository/create_product_repo_impl.dart';
import 'package:my_office/features/create_product/domain/repository/create_product_repository.dart';
import 'package:my_office/features/create_product/domain/use_case/create_product_use_case.dart';
import 'package:my_office/features/create_product/presentation/provider/create_product_provider.dart';
import 'package:my_office/features/employee_of_the_week/data/data_source/employee_fb_data_source.dart';
import 'package:my_office/features/employee_of_the_week/domain/repository/employee_repository.dart';
import 'package:my_office/features/employee_of_the_week/domain/use_case/all_staff_names_use_case.dart';
import 'package:my_office/features/employee_of_the_week/domain/use_case/update_pr_name_reason_use_case.dart';
import 'package:my_office/features/employee_of_the_week/presentation/provider/employee_of_the_week_provider.dart';
import 'package:my_office/features/finance/data/data_source/finance_fb_data_source.dart';
import 'package:my_office/features/finance/data/data_source/finance_fb_data_source_impl.dart';
import 'package:my_office/features/food_count/data/data_source/food_count_data_source_impl.dart';
import 'package:my_office/features/food_count/data/repository/food_count_repo_impl.dart';
import 'package:my_office/features/food_count/domain/repository/food_count_repository.dart';
import 'package:my_office/features/food_count/domain/use_case/all_food_count_use_case.dart';
import 'package:my_office/features/home/data/repository/home_repo_impl.dart';
import 'package:my_office/features/home/domain/use_case/get_all_birthday_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_installation_members_list_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_management_list_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_punching_time_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_random_number_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_staff_access_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_staff_details_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_tl_list_use_case.dart';
import 'package:my_office/features/hr_access/data/data_source/hr_access_fb_data_source.dart';
import 'package:my_office/features/hr_access/data/data_source/hr_access_fb_data_source_impl.dart';
import 'package:my_office/features/hr_access/data/repository/hr_access_repo_impl.dart';
import 'package:my_office/features/hr_access/domain/repository/hr_access_repository.dart';
import 'package:my_office/features/hr_access/domain/use_case/all_staff_details_use_case.dart';
import 'package:my_office/features/hr_access/domain/use_case/create_account_use_case.dart';
import 'package:my_office/features/hr_access/domain/use_case/update_timing_for_employees_use_case.dart';
import 'package:my_office/features/pr_bucket/data/data_source/pr_bucket_fb_data_source.dart';
import 'package:my_office/features/pr_bucket/data/data_source/pr_bucket_fb_data_source_impl.dart';
import 'package:my_office/features/pr_bucket/data/repository/pr_bucket_repo_impl.dart';
import 'package:my_office/features/pr_bucket/domain/repository/pr_bucket_repository.dart';
import 'package:my_office/features/pr_bucket/domain/use_case/bucket_values_case.dart';
import 'package:my_office/features/pr_bucket/domain/use_case/get_bucket_names_case.dart';
import 'package:my_office/features/pr_bucket/domain/use_case/get_customer_data_case.dart';
import 'package:my_office/features/pr_bucket/domain/use_case/get_pr_names_case.dart';
import 'package:my_office/features/pr_bucket/presentation/provider/pr_bucket_provider.dart';
import 'package:my_office/features/pr_dashboard/data/data_source/pr_dash_fb_data_source.dart';
import 'package:my_office/features/pr_dashboard/domain/repository/pr_dash_repository.dart';
import 'package:my_office/features/pr_dashboard/domain/use_case/pr_dashboard_details_use_case.dart';
import 'package:my_office/features/pr_dashboard/domain/use_case/update_pr_dashboard_use_case.dart';
import 'package:my_office/features/pr_reminder/data/data_source/pr_reminder_data_source_impl.dart';
import 'package:my_office/features/pr_reminder/data/data_source/pr_reminder_fb_data_source.dart';
import 'package:my_office/features/pr_reminder/data/repository/pr_reminder_repo_impl.dart';
import 'package:my_office/features/pr_reminder/domain/repository/pr_reminder_repository.dart';
import 'package:my_office/features/pr_reminder/domain/use_case/pr_reminder_staff_names_use_case.dart';
import 'package:my_office/features/pr_reminder/presentation/provider/pr_reminder_provider.dart';
import 'package:my_office/features/proxy_attendance/data/data_source/proxy_attendance_fb_data_source.dart';
import 'package:my_office/features/proxy_attendance/data/data_source/proxy_attendance_fb_data_source_impl.dart';
import 'package:my_office/features/proxy_attendance/data/repository/proxy_attendance_repo_impl.dart';
import 'package:my_office/features/proxy_attendance/domain/repository/proxy_attendance_repository.dart';
import 'package:my_office/features/proxy_attendance/domain/use_case/proxy_staff_names_use_case.dart';
import 'package:my_office/features/proxy_attendance/domain/use_case/save_check_in_use_case.dart';
import 'package:my_office/features/proxy_attendance/domain/use_case/save_check_out_use_case.dart';
import 'package:my_office/features/proxy_attendance/presentation/provider/proxy_attendance_provider.dart';
import 'package:my_office/features/refreshment/data/data_source/refreshment_fb_data_source.dart';
import 'package:my_office/features/refreshment/data/data_source/refreshment_fb_data_source_impl.dart';
import 'package:my_office/features/refreshment/data/repository/refreshment_repo_impl.dart';
import 'package:my_office/features/refreshment/domain/repository/refreshment_repository.dart';
import 'package:my_office/features/sales_points/data/data_source/sales_point_fb_data_source.dart';
import 'package:my_office/features/sales_points/data/data_source/sales_point_fb_data_source_impl.dart';
import 'package:my_office/features/sales_points/data/repository/sales_point_repo_impl.dart';
import 'package:my_office/features/sales_points/domain/repository/sales_point_repository.dart';
import 'package:my_office/features/sales_points/domain/use_case/get_product_details_use_case.dart';
import 'package:my_office/features/sales_points/domain/use_case/get_products_use_case.dart';
import 'package:my_office/features/search_leads/data/data_source/search_leads_fb_data_source.dart';
import 'package:my_office/features/search_leads/data/data_source/search_leads_fb_data_source_impl.dart';
import 'package:my_office/features/search_leads/data/repository/search_leads_repo_impl.dart';
import 'package:my_office/features/search_leads/domain/repository/search_leads_repository.dart';
import 'package:my_office/features/search_leads/presentation/provider/feedback_button_provider.dart';
import 'package:my_office/features/staff_details/data/data_source/staff_detail_fb_data_source.dart';
import 'package:my_office/features/staff_details/data/data_source/staff_detail_fb_data_source_impl.dart';
import 'package:my_office/features/staff_details/data/repository/staff_detail_repo_impl.dart';
import 'package:my_office/features/staff_details/domain/repository/staff_detail_repository.dart';
import 'package:my_office/features/staff_details/domain/use_case/remove_staff_detail_use_case.dart';
import 'package:my_office/features/staff_details/domain/use_case/staff_detail_use_case.dart';
import 'package:my_office/features/staff_details/presentation/provider/staff_detail_provider.dart';
import 'package:my_office/features/suggestions/data/data_source/suggestion_fb_data_source.dart';
import 'package:my_office/features/suggestions/data/data_source/suggestion_fb_data_source_impl.dart';
import 'package:my_office/features/suggestions/data/repository/suggestion_repo_impl.dart';
import 'package:my_office/features/suggestions/domain/repository/suggestion_repository.dart';
import 'package:my_office/features/suggestions/domain/use_case/add_suggestion_use_case.dart';
import 'package:my_office/features/theme/data/repository/theme_repository_impl.dart';
import 'package:my_office/features/view_suggestions/data/data_source/view_suggestion_fb_data_source.dart';
import 'package:my_office/features/view_suggestions/data/data_source/view_suggestion_fb_data_source_impl.dart';
import 'package:my_office/features/view_suggestions/data/repository/view_suggestion_repo_impl.dart';
import 'package:my_office/features/view_suggestions/domain/repository/view_suggestion_repository.dart';
import 'package:my_office/features/view_suggestions/domain/use_case/view_suggestion_use_case.dart';
import 'package:my_office/features/work_details/data/data_source/work_detail_fb_data_source.dart';
import 'package:my_office/features/work_details/data/data_source/work_entry_fb_data_source_impl.dart';
import 'package:my_office/features/work_details/data/repository/work_detail_repo_impl.dart';
import 'package:my_office/features/work_details/domain/repository/work_detail_repository.dart';
import 'package:my_office/features/work_entry/data/data_source/work_entry_fb_data_source.dart';
import 'package:my_office/features/work_entry/data/data_source/work_entry_fb_data_source_impl.dart';
import 'package:my_office/features/work_entry/data/repository/work_entry_repo_impl.dart';
import 'package:my_office/features/work_entry/domain/repository/work_entry_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/employee_of_the_week/data/data_source/employee_fb_data_source_impl.dart';
import '../../features/employee_of_the_week/data/repository/employee_repo_impl.dart';
import '../../features/food_count/data/data_source/food_count_fb_data_source.dart';
import '../../features/home/data/data_source/home_fb_data_source.dart';
import '../../features/home/data/data_source/home_fb_data_source_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../../features/home/presentation/provider/home_provider.dart';
import '../../features/pr_dashboard/data/data_source/pr_dash_fb_data_source_impl.dart';
import '../../features/pr_dashboard/data/repository/pr_dash_repo_impl.dart';
import '../../features/pr_reminder/domain/use_case/get_pr_reminders_use_case.dart';
import '../../features/theme/data/local_data_source/theme_local_data_source.dart';
import '../../features/theme/data/local_data_source/theme_local_data_source_impl.dart';
import '../../features/theme/domain/repository/theme_repository.dart';
import '../../features/theme/domain/use_case/get_app_theme_use_case.dart';
import '../../features/theme/domain/use_case/reset_app_theme_use_case.dart';
import '../../features/theme/domain/use_case/update_app_theme_use_case.dart';
import '../../features/theme/presentation/provider/theme_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PROVIDERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

  ///AUTH PROVIDER
  sl.registerFactory<AuthenticationProvider>(
    () => AuthenticationProvider(
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
    ),
  );

  ///EMPLOYEE OF THE WEEK PROVIDER
  sl.registerFactory<EmployeeProvider>(
    () => EmployeeProvider(
      sl.call(),
    ),
  );

  ///CREATE NEW LEAD
  sl.registerFactory<CreateLeadProvider>(
    () => CreateLeadProvider(
      sl.call(),
    ),
  );

  ///CREATE PRODUCT PROVIDER
  sl.registerFactory<CreateProductProvider>(
    () => CreateProductProvider(
      sl.call(),
    ),
  );

  ///PROXY ATTENDANCE PROVIDER
  sl.registerFactory<ProxyAttendanceProvider>(
    () => ProxyAttendanceProvider(
      sl.call(),
      sl.call(),
      sl.call(),
    ),
  );

  ///PR REMINDER PROVIDER
  sl.registerFactory<PrReminderProvider>(
    () => PrReminderProvider(
      sl.call(),
      sl.call(),
    ),
  );

  ///STAFF DETAIL PROVIDER
  sl.registerFactory<StaffDetailProvider>(
    () => StaffDetailProvider(
      sl.call(),
      sl.call(),
    ),
  );

  ///FEEDBACK BUTTON PROVIDER
  sl.registerFactory<FeedbackButtonProvider>(
        () => FeedbackButtonProvider(),
  );

  ///THEME PROVIDER
  sl.registerFactory<ThemeProvider>(
        () => ThemeProvider(
          sl.call(),
          sl.call(),
          sl.call(),
        ),
  );

  ///PR BUCKET PROVIDER
  sl.registerFactory<PrBucketProvider>(
        () => PrBucketProvider(
          sl.call(),
          sl.call(),
          sl.call(),
          sl.call(),
    ),
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ USE CASES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

  ///RESET PASSWORD
  sl.registerLazySingleton<ResetPasswordCase>(
    () => ResetPasswordCase(authRepository: sl.call()),
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

  ///ALL STAFF NAMES
  sl.registerLazySingleton<AllStaffNamesCase>(
    () => AllStaffNamesCase(employeeRepository: sl.call()),
  );

  ///UPDATE PR NAME REASON
  sl.registerLazySingleton<UpdatePrNameReasonCase>(
    () => UpdatePrNameReasonCase(employeeRepository: sl.call()),
  );

  ///PR DASHBOARD DETAILS
  sl.registerLazySingleton<PrDashboardCase>(
    () => PrDashboardCase(prDashRepository: sl.call()),
  );

  ///UPDATE PR DASHBOARD DETAILS
  sl.registerLazySingleton<UpdatePrDashboardCase>(
    () => UpdatePrDashboardCase(prDashRepository: sl.call()),
  );

  ///CREATE LEAD
  sl.registerLazySingleton<CreateLeadCase>(
    () => CreateLeadCase(createLeadRepository: sl.call()),
  );

  ///CREATE PRODUCT
  sl.registerLazySingleton<CreateProductCase>(
    () => CreateProductCase(createProductRepository: sl.call()),
  );

  ///FOOD COUNT DETAILS
  sl.registerLazySingleton<AllFoodCountCase>(
    () => AllFoodCountCase(foodCountRepository: sl.call()),
  );

  ///PROXY ATTENDANCE ALL STAFFS
  sl.registerLazySingleton<ProxyStaffNamesCase>(
    () => ProxyStaffNamesCase(proxyAttendanceRepository: sl.call()),
  );

  ///SAVE PROXY CHECK IN
  sl.registerLazySingleton<SaveCheckInCase>(
    () => SaveCheckInCase(proxyAttendanceRepository: sl.call()),
  );

  ///SAVE PROXY CHECK OUT
  sl.registerLazySingleton<SaveCheckOutCase>(
    () => SaveCheckOutCase(proxyAttendanceRepository: sl.call()),
  );

  ///PR REMINDER STAFF NAMES
  sl.registerLazySingleton<PrReminderStaffNamesCase>(
    () => PrReminderStaffNamesCase(prReminderRepository: sl.call()),
  );

  ///ALL PR REMINDERS
  sl.registerLazySingleton<GetPrRemindersCase>(
    () => GetPrRemindersCase(prReminderRepository: sl.call()),
  );

  ///ALL STAFF NAMES
  sl.registerLazySingleton<StaffDetailCase>(
    () => StaffDetailCase(staffDetailRepository: sl.call()),
  );

  ///REMOVE STAFF DETAILS
  sl.registerLazySingleton<RemoveStaffDetailCase>(
    () => RemoveStaffDetailCase(staffDetailRepository: sl.call()),
  );

  ///ADD SUGGESTION SCREEN
  sl.registerLazySingleton<AddSuggestionCase>(
    () => AddSuggestionCase(suggestionRepository: sl.call()),
  );

  ///VIEW SUGGESTION
  sl.registerLazySingleton<ViewSuggestionsCase>(
    () => ViewSuggestionsCase(viewSuggestionsRepository: sl.call()),
  );

  ///GET PRODUCTS
  sl.registerLazySingleton<GetProductsCase>(
        () => GetProductsCase(sl.call()),
  );

  ///GET PRODUCT DETAILS
  sl.registerLazySingleton<GetProductDetailsCase>(
        () => GetProductDetailsCase(sl.call()),
  );

  ///HR ACCESS STAFFS
  sl.registerLazySingleton<AllStaffDetailsCase>(
        () => AllStaffDetailsCase(hrAccessRepository: sl.call()),
  );

  ///UPDATE HR TIMING
  sl.registerLazySingleton<UpdateTimingForEmployeesCase>(
        () => UpdateTimingForEmployeesCase(hrAccessRepository: sl.call()),
  );

  ///CREATE STAFF ACCOUNT
  sl.registerLazySingleton<CreateAccountCase>(
        () => CreateAccountCase(hrAccessRepository: sl.call()),
  );

  ///GET APP THEME USE CASE
  sl.registerLazySingleton<GetAppThemeUseCase>(
        () => GetAppThemeUseCase(themeRepository: sl.call()),
  );

  ///RESET APP THEME USE CASE
  sl.registerLazySingleton<ResetAppThemeUseCase>(
        () => ResetAppThemeUseCase(themeRepository: sl.call()),
  );

  ///UPDATE APP THEME USE CASE
  sl.registerLazySingleton<UpdateAppThemeUseCase>(
        () => UpdateAppThemeUseCase(themeRepository: sl.call()),
  );

  ///PR BUCKET STAFF NAMES USE CASE
  sl.registerLazySingleton<GetPrNamesCase>(
        () => GetPrNamesCase(prBucketRepository: sl.call()),
  );

  ///PR BUCKET NAMES USE CASE
  sl.registerLazySingleton<GetBucketNamesCase>(
        () => GetBucketNamesCase(prBucketRepository: sl.call()),
  );

  ///PR BUCKET VALUES USE CASE
  sl.registerLazySingleton<BucketValuesCase>(
        () => BucketValuesCase(prBucketRepository: sl.call()),
  );

  ///GET CUSTOMER DATA USE CASE
  sl.registerLazySingleton<GetCustomerDataCase>(
        () => GetCustomerDataCase(prBucketRepository: sl.call()),
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ REPOSITORIES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

  ///AUTH
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepoImpl(sl.call(), sl.call()),
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
    () => CreateLeadRepoImpl(sl.call()),
  );

  ///CREATE PRODUCT SCREEN
  sl.registerLazySingleton<CreateProductRepository>(
    () => CreateProductRepoImpl(),
  );

  ///FOOD COUNT SCREEN
  sl.registerLazySingleton<FoodCountRepository>(
    () => FoodCountRepoImpl(sl.call()),
  );

  ///PROXY ATTENDANCE SCREEN
  sl.registerLazySingleton<ProxyAttendanceRepository>(
    () => ProxyAttendanceRepoImpl(sl.call()),
  );

  ///PR REMINDER SCREEN
  sl.registerLazySingleton<PrReminderRepository>(
    () => PrReminderRepoImpl(sl.call()),
  );

  ///STAFF DETAILS SCREEN
  sl.registerLazySingleton<StaffDetailRepository>(
    () => StaffDetailRepoImpl(staffDetailFbDataSource: sl.call()),
  );

  ///ADD SUGGESTION SCREEN
  sl.registerLazySingleton<SuggestionRepository>(
    () => SuggestionRepoImpl(sl.call()),
  );

  ///VIEW SUGGESTION SCREEN
  sl.registerLazySingleton<ViewSuggestionsRepository>(
    () => ViewSuggestionsRepoImpl(sl.call()),
  );

  ///WORK ENTRY SCREEN
  sl.registerLazySingleton<WorkEntryRepository>(
    () => WorkEntryRepoImpl(workEntryFbDataSource: sl.call()),
  );

  ///WORK DETAILS SCREEN
  sl.registerLazySingleton<WorkDetailRepository>(
    () => WorkDetailRepoImpl(workDetailFbDataSource: sl.call()),
  );

  ///SALES POINT SCREEN
  sl.registerLazySingleton<SalesPointRepository>(
        () => SalesPointRepoImpl(sl.call()),
  );

  ///REFRESHMENT SCREEN
  sl.registerLazySingleton<RefreshmentRepository>(
        () => RefreshmentRepoImpl(sl.call()),
  );

  ///CUSTOMER LEADS SCREEN
  sl.registerLazySingleton<SearchLeadsRepository>(
        () => SearchLeadsRepoImpl(sl.call()),
  );

  ///HR ACCESS REPOSITORY
  sl.registerLazySingleton<HrAccessRepository>(
        () => HrAccessRepoImpl(sl.call()),
  );

  ///THEME REPOSITORY
  sl.registerLazySingleton<ThemeRepository>(
        () => ThemeRepositoryImpl(localDataSource: sl.call(),),
  );

  ///PR BUCKET REPOSITORY
  sl.registerLazySingleton<PrBucketRepository>(
        () => PrBucketRepoImpl(prBucketFbDataSource: sl.call(),),
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
    () => PrDashFbDataSourceImpl(),
  );

  ///CREATE LEAD SCREEN
  sl.registerLazySingleton<CreateLeadFbDataSource>(
    () => CreateLeadFbDataSourceImpl(),
  );

  ///FOOD COUNT SCREEN
  sl.registerLazySingleton<FoodCountFbDataSource>(
    () => FoodCountFbDataSourceImpl(),
  );

  ///FINANCE SCREEN
  sl.registerLazySingleton<FinanceFbDataSource>(
    () => FinanceFbDataSourceImpl(),
  );

  ///PROXY ATTENDANCE SCREEN
  sl.registerLazySingleton<ProxyAttendanceFbDataSource>(
    () => ProxyAttendanceFbDataSourceImpl(),
  );

  ///PR REMINDER SCREEN
  sl.registerLazySingleton<PrReminderFbDataSource>(
    () => PrReminderFbDataSourceImpl(),
  );

  ///ADD SUGGESTION SCREEN
  sl.registerLazySingleton<SuggestionFbDataSource>(
    () => SuggestionFbDataSourceImpl(),
  );

  ///STAFF DETAIL SCREEN
  sl.registerLazySingleton<StaffDetailFbDataSource>(
    () => StaffDetailFbDataSourceImpl(),
  );

  ///VIEW SUGGESTION SCREEN
  sl.registerLazySingleton<ViewSuggestionsFbDataSource>(
    () => ViewSuggestionsFbDataSourceImpl(),
  );

  ///WORK ENTRY SCREEN
  sl.registerLazySingleton<WorkEntryFbDataSource>(
    () => WorkEntryFbDataSourceImpl(),
  );

  ///WORK DETAILS SCREEN
  sl.registerLazySingleton<WorkDetailFbDataSource>(
    () => WorkDetailFbDataSourceImpl(),
  );

  ///SALES POINT SCREEN
  sl.registerLazySingleton<SalesPointFbDataSource>(
        () => SalesPointFbDataSourceImpl(),
  );

  ///REFRESHMENT SCREEN
  sl.registerLazySingleton<RefreshmentFbDataSource>(
        () => RefreshmentFbDataSourceImpl(),
  );

  ///CUSTOMER LEADS SCREEN
  sl.registerLazySingleton<SearchLeadsFbDataSource>(
        () => SearchLeadsFbDataSourceImpl(),
  );

  ///AUTH LOCAL DATA SOURCE
  sl.registerLazySingleton<AuthLocalDataSourceImpl>(
        () => AuthLocalDataSourceImpl(sl.call()),
  );

  ///HR ACCESS STAFFS SCREEN
  sl.registerLazySingleton<HrAccessFbDataSource>(
        () => HrAccessFbDataSourceImpl(),
  );

  ///THEME DATA SCREEN
  sl.registerLazySingleton<ThemeLocalDataSource>(
        () => ThemeLocalDataSourceImpl(),
  );

  ///PR BUCKET DATA SOURCE
  sl.registerLazySingleton<PrBucketFbDataSource>(
        () => PrBucketFbDataSourceImpl(),
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EXTERNAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
  final fbDb = FirebaseDatabase.instance;
  final fbAuth = FirebaseAuth.instance;
  final sp = await SharedPreferences.getInstance();

  sl.registerLazySingleton<FirebaseAuth>(() => fbAuth);
  sl.registerLazySingleton<FirebaseDatabase>(() => fbDb);
  sl.registerLazySingleton<DatabaseReference>(
    () => FirebaseDatabase.instance.ref(),
  );
  sl.registerLazySingleton<SharedPreferences>(() => sp);
}
