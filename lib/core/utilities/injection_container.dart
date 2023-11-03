import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
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

final sl = GetIt.instance;
Future<void> init() async {

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PROVIDERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

  ///Auth Provider
  sl.registerFactory<AuthProvider>(
        () => AuthProvider(
     sl.call(),
     sl.call(),
     sl.call(),
     sl.call(),
     sl.call(),
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

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ REPOSITORIES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

  ///AUTH
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepoImpl(sl.call()),
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DATA SOURCE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

  ///AUTH
  sl.registerLazySingleton<AuthFbDataSource>(() => AuthFbDataSourceImpl(sl.call(), sl.call()));


  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EXTERNAL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
  final fbDb = FirebaseDatabase.instance;
  final fbAuth = FirebaseAuth.instance;

  sl.registerLazySingleton<FirebaseAuth>(() => fbAuth);
  sl.registerLazySingleton<FirebaseDatabase>(() => fbDb);
}
