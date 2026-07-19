import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:get_it/get_it.dart';

/// Global service locator instance.
/// Access any registered dependency from anywhere via: getIt<<ApiService()
final getIt = GetIt.instance;

/// Call this once, at app startup (in main.dart), before runApp().
void setupServiceLocator() {
  // registerLazySingleton: the ApiService (and its internal Dio) is created
  // only the first time it's requested, then the SAME instance is reused
  // for every getIt<ApiService>() call afterwards.
  getIt.registerLazySingleton<ApiService>(() => ApiService(baseUrl: kBaseUrl));

  // If you have other singletons (repositories, local storage, etc.),
  // register them here too, e.g.:
  // getIt.registerLazySingleton<ProductsRepository>(
  //   () => ProductsRepositoryImpl(apiService: getIt<ApiService>()),
  // );
}
