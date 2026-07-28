import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/network/dio_error_interceptor.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/auth/data/auth_data_source/auth_remote_data_source_impl.dart';
import 'package:e_commerce/features/auth/data/repo/auth_repo_auth.dart';

import 'package:e_commerce/features/auth/domain/auth_data_source/auth_remote_data_source.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';
import 'package:e_commerce/features/auth/domain/use_case/log_out_use_case.dart';
import 'package:e_commerce/features/auth/domain/use_case/sign_in_usecase.dart';
import 'package:e_commerce/features/auth/domain/use_case/sign_up_usecase.dart';
import 'package:e_commerce/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_out/cubit/sign_out_cubit.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_up_cubit/sign_up_cubit.dart';
import 'package:e_commerce/features/home/data/datasources/home_remote_data_source.dart';
import 'package:e_commerce/features/home/data/repo/home_repo_impl.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';
import 'package:e_commerce/features/home/domain/usecases/get_best_selling_products_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_new_products_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_products_by_category_usecase.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/get_category_products_cubit/get_category_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/home_cubit/home_cubit.dart';

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

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton(() => Connectivity());

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(DioErrorInterceptor());
    return dio;
  });
  // Home Data Source
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  // Home Repository
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Home Use Cases
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<HomeRepository>()),
  );

  getIt.registerLazySingleton<GetBestSellingProductsUseCase>(
    () => GetBestSellingProductsUseCase(getIt<HomeRepository>()),
  );

  getIt.registerLazySingleton<GetNewProductsUseCase>(
    () => GetNewProductsUseCase(getIt<HomeRepository>()),
  );

  getIt.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(getIt<HomeRepository>()),
  );

  // Home Cubit
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      getCategoriesUseCase: getIt(),
      getBestSellingProductsUseCase: getIt(),
      getNewProductsUseCase: getIt(),
    ),
  );

  // Category Products Cubit
  getIt.registerFactoryParam<CategoryProductsCubit, String, void>(
    (categoryId, _) => CategoryProductsCubit(
      getProductsByCategoryUseCase: getIt<GetProductsByCategoryUseCase>(),
      categoryId: categoryId,
    ),
  );

  getIt.registerLazySingleton<SignOutCubit>(
    () => SignOutCubit(getIt<LogOutUseCase>()),
  );
  getIt.registerLazySingleton<LogOutUseCase>(
    () => LogOutUseCase(authRepository: getIt<AuthRepository>()),
  );
}
