import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/auth/data/auth_data_source/auth_remote_data_source_impl.dart';
import 'package:e_commerce/features/auth/data/repo/auth_repo_auth.dart';

import 'package:e_commerce/features/auth/domain/auth_data_source/auth_remote_data_source.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';
import 'package:e_commerce/features/auth/domain/use_case/sign_in_usecase.dart';
import 'package:e_commerce/features/auth/domain/use_case/sign_up_usecase.dart';
import 'package:e_commerce/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_up_cubit/sign_up_cubit.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // =========================
  // Core
  // =========================

  getIt.registerLazySingleton<ApiService>(() => ApiService(baseUrl: kBaseUrl));

  // =========================
  // Data Source
  // =========================

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  // =========================
  // Repository
  // =========================

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // =========================
  // Use Cases
  // =========================

  getIt.registerLazySingleton<SignInUsecase>(
    () => SignInUsecase(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignUpUsecase>(
    () => SignUpUsecase(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(authRepository: getIt<AuthRepository>()),
  );

  // =========================
  // Cubits
  // =========================

  getIt.registerFactory<SignInCubit>(
    () => SignInCubit(signInUsecase: getIt<SignInUsecase>()),
  );

  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(signUpUsecase: getIt<SignUpUsecase>()),
  );
}
