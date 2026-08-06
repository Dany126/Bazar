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
import 'package:e_commerce/features/home/domain/usecases/get_all_categories_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products_by_categories_use_case.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_best_selling_product_use_case.dart';
import 'package:e_commerce/features/home/domain/usecases/get_newest_product_use_case.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // =========================
  // Core
  // =========================

  getIt.registerLazySingleton<ApiService>(() => ApiService(baseUrl: kBaseUrl));

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

  // =========================
  // Auth: Data Source
  // =========================

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  // =========================
  // Auth: Repository
  // =========================

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // =========================
  // Auth: Use Cases
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

  getIt.registerLazySingleton<LogOutUseCase>(
    () => LogOutUseCase(authRepository: getIt<AuthRepository>()),
  );

  // =========================
  // Auth: Cubits
  // =========================

  getIt.registerFactory<SignInCubit>(
    () => SignInCubit(signInUsecase: getIt<SignInUsecase>()),
  );

  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(signUpUsecase: getIt<SignUpUsecase>()),
  );

  getIt.registerFactory<SignOutCubit>(
    () => SignOutCubit(getIt<LogOutUseCase>()),
  );

  // =========================
  // Home: Data Source
  // =========================

  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  // =========================
  // Home: Repository
  // =========================

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepositoryImpl(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // =========================
  // Home: Use Cases
  // =========================

  getIt.registerLazySingleton<GetAllCategoriesUseCase>(
    () => GetAllCategoriesUseCase(getIt<HomeRepo>()),
  );

  getIt.registerLazySingleton<GetAllProductsUseCase>(
    () => GetAllProductsUseCase(getIt<HomeRepo>()),
  );

  getIt.registerLazySingleton<GetAllProductsByCategoriesUseCase>(
    () => GetAllProductsByCategoriesUseCase(getIt<HomeRepo>()),
  );
  getIt.registerLazySingleton<GetBestSellingProductUseCase>(
    () => GetBestSellingProductUseCase(getIt<HomeRepo>()),
  );
  getIt.registerLazySingleton<GetNewtestProductUseCase>(
    () => GetNewtestProductUseCase(getIt<HomeRepo>()),
  );

  // =========================
  // Home: Cubits
  // =========================

  getIt.registerFactory<GetCategoriesCubit>(
    () => GetCategoriesCubit(
      getAllCategoriesUseCase: getIt<GetAllCategoriesUseCase>(),
    ),
  );

  getIt.registerFactory<GetProductsCubit>(
    () => GetProductsCubit(
      getAllProductsUseCase: getIt<GetAllProductsUseCase>(),
      getAllProductsByCategoriesUseCase:
          getIt<GetAllProductsByCategoriesUseCase>(),
    ),
  );
}
