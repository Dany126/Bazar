import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/features/admin/data/datasources/admin_users_remote_data_source.dart';
import 'package:e_commerce/features/admin/data/repositories/admin_users_repository_impl.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_users_repository.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_users.dart';
import 'package:get_it/get_it.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/network/dio_error_interceptor.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/core/notifications/fcm_service.dart';
import 'package:e_commerce/core/notifications/socket_service.dart';
import 'package:e_commerce/core/services/api_services.dart';

// ==========================================================
// ADDRESS
// ==========================================================
import 'package:e_commerce/features/address/data/data_source/address_remote_data_source_impl.dart';
import 'package:e_commerce/features/address/data/repo/address_repo_impl.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';
import 'package:e_commerce/features/address/domain/use_case/add_address_usecase.dart';
import 'package:e_commerce/features/address/domain/use_case/delete_address_usecase.dart';
import 'package:e_commerce/features/address/domain/use_case/edit_address_usecase.dart';
import 'package:e_commerce/features/address/domain/use_case/get_addresses_usecase.dart';
import 'package:e_commerce/features/address/domain/use_case/get_current_location_usecase.dart';
import 'package:e_commerce/features/address/domain/use_case/reverse_geocode_usecase.dart';
import 'package:e_commerce/features/address/domain/use_case/search_places_usecase.dart';
import 'package:e_commerce/features/address/domain/use_case/set_default_address_usecase.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';

// ==========================================================
// ADMIN
// ==========================================================
import 'package:e_commerce/features/admin/data/datasources/admin_dashboard_remote_data_source.dart';
import 'package:e_commerce/features/admin/data/repositories/admin_dashboard_repository_impl.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_dashboard_repository.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:e_commerce/features/admin/data/datasources/admin_product_remote_data_source.dart';
import 'package:e_commerce/features/admin/data/repositories/admin_product_repository_impl.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_product_repository.dart';
import 'package:e_commerce/features/admin/domain/usecases/create_admin_product.dart';
import 'package:e_commerce/features/admin/domain/usecases/delete_admin_product.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_products.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_product.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_users_cubit.dart';

// ==========================================================
// AUTH
// ==========================================================
import 'package:e_commerce/features/auth/data/auth_data_source/auth_local_data_source.dart';
import 'package:e_commerce/features/auth/data/auth_data_source/auth_remote_data_source_impl.dart';
import 'package:e_commerce/features/auth/data/repo/auth_repo_auth.dart';
import 'package:e_commerce/features/auth/domain/auth_data_source/auth_remote_data_source.dart';
import 'package:e_commerce/features/auth/domain/repo/auth_repo.dart';
import 'package:e_commerce/features/auth/domain/use_case/log_out_use_case.dart';
import 'package:e_commerce/features/auth/domain/use_case/sign_in_usecase.dart';
import 'package:e_commerce/features/auth/domain/use_case/sign_up_usecase.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_out/cubit/sign_out_cubit.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_up_cubit/sign_up_cubit.dart';

// ==========================================================
// CART
// ==========================================================
import 'package:e_commerce/features/cart/data/data_source/remote_data_source_impl.dart';
import 'package:e_commerce/features/cart/data/repo/cart_repo_impl.dart';
import 'package:e_commerce/features/cart/domain/data_source/remote_data_source.dart';
import 'package:e_commerce/features/cart/domain/repo/cart_repo.dart';
import 'package:e_commerce/features/cart/domain/use_case/add_to_cart_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/apply_coupon_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/get_cart_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/remove_all_from_cart_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/remove_from_cart_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/update_cart_item_quantity_use_case.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';

// ==========================================================
// CHECKOUT
// ==========================================================
import 'package:e_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';

// ==========================================================
// HOME
// ==========================================================
import 'package:e_commerce/features/home/data/datasources/home_remote_data_source.dart';
import 'package:e_commerce/features/home/data/repo/home_repo_impl.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';
import 'package:e_commerce/features/home/domain/usecases/change_to_is_favourite.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_categories_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products_by_categories_use_case.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_best_selling_product_use_case.dart';
import 'package:e_commerce/features/home/domain/usecases/get_favourite_products_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_newest_product_use_case.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';

// ==========================================================
// NOTIFICATION
// ==========================================================
import 'package:e_commerce/features/notification/data/repo/notification_repository_impl.dart';
import 'package:e_commerce/features/notification/domain/repo/notification_repository.dart';
import 'package:e_commerce/features/notification/domain/usecases/delete_notification.dart';
import 'package:e_commerce/features/notification/domain/usecases/get_fav_notification.dart';
import 'package:e_commerce/features/notification/domain/usecases/get_notifications.dart';
import 'package:e_commerce/features/notification/domain/usecases/get_read_notification.dart';
import 'package:e_commerce/features/notification/domain/usecases/get_unread_notification.dart';
import 'package:e_commerce/features/notification/domain/usecases/mark_notification_as_fav.dart';
import 'package:e_commerce/features/notification/domain/usecases/mark_notification_as_read.dart';
import 'package:e_commerce/features/notification/presentation/cubit/notification_cubit.dart';

// ==========================================================
// ORDER
// ==========================================================
import 'package:e_commerce/features/order/data/data_source/remote_data_source/order_remo_data_source_impl.dart';
import 'package:e_commerce/features/order/data/repo/order_repo_impl.dart';
import 'package:e_commerce/features/order/domin/data_source/remote_data_source/order_remo_data_source.dart';
import 'package:e_commerce/features/order/domin/repo/order_repo.dart';
import 'package:e_commerce/features/order/domin/use_case/create_order_use_case.dart';
import 'package:e_commerce/features/order/domin/use_case/get_order_use_case.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';

// ==========================================================
// PAYMENT
// ==========================================================
import 'package:e_commerce/features/payment/data/data_source/paymob_remote_data_source.dart';
import 'package:e_commerce/features/payment/data/repo/paymob_repository_impl.dart';
import 'package:e_commerce/features/payment/domain/repo/paymob_repository.dart';
import 'package:e_commerce/features/payment/domain/use_case/create_paymob_payment_use_case.dart';

// ==========================================================
// PAYMENT METHOD
// ==========================================================
import 'package:e_commerce/features/payment_method/data/data_source/payment_local_data_source_impl.dart';
import 'package:e_commerce/features/payment_method/data/repo/payment_method_repo_impl.dart';
import 'package:e_commerce/features/payment_method/domain/repo/payment_repo.dart';
import 'package:e_commerce/features/payment_method/domain/use_case/add_card_use_case.dart';
import 'package:e_commerce/features/payment_method/domain/use_case/get_saved_cards_use_case.dart';
import 'package:e_commerce/features/payment_method/domain/use_case/remove_card_use_case.dart';
import 'package:e_commerce/features/payment_method/presentation/model_view/cubit/payment_cubit.dart';

// ==========================================================
// PRODUCT DETAILS
// ==========================================================
import 'package:e_commerce/features/product_details/data/data_source/remote_data_source_impl.dart';
import 'package:e_commerce/features/product_details/data/data_source/review_remote_data_source.dart';
import 'package:e_commerce/features/product_details/data/repo/product_details_repo_impl.dart';
import 'package:e_commerce/features/product_details/data/repo/review_repository_impl.dart';
import 'package:e_commerce/features/product_details/domain/data_source/remote_data_source.dart';
import 'package:e_commerce/features/product_details/domain/repo/product_details_repo.dart';
import 'package:e_commerce/features/product_details/domain/repo/review_repository.dart';
import 'package:e_commerce/features/product_details/domain/use_case/add_product_review_use_case.dart';
import 'package:e_commerce/features/product_details/domain/use_case/get_product_details_use_case.dart';
import 'package:e_commerce/features/product_details/presentation/model_view/product_details_cubit/product_details_cubit.dart';
import 'package:e_commerce/features/product_details/presentation/model_view/review_cubit/review_cubit.dart';

// ==========================================================
// SEARCH
// ==========================================================
import 'package:e_commerce/features/search/data/data_source/search_remote_data_impl.dart';
import 'package:e_commerce/features/search/data/repo/search_repo_impl.dart';
import 'package:e_commerce/features/search/domain/data_source/search_remote_data.dart';
import 'package:e_commerce/features/search/domain/repo/search_repo.dart';
import 'package:e_commerce/features/search/domain/use_case/search_products_use_case.dart';
import 'package:e_commerce/features/search/presentation/cubit/search_cubit.dart';

// ==========================================================

import 'package:dio/browser.dart';
import 'package:flutter/foundation.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator({required CookieJar cookieJar}) async {
  // ==========================================================
  // RESET
  // ==========================================================

  await getIt.reset();

  // ==========================================================
  // CORE
  // ==========================================================

  getIt.registerLazySingleton<CookieJar>(() => cookieJar);

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  getIt.registerLazySingleton<NetworkInfoImpl>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  // ==========================================================
  // DIO
  // ==========================================================

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Required for refreshToken HttpOnly cookie on Flutter Web
    if (kIsWeb) {
      dio.httpClientAdapter = BrowserHttpClientAdapter()
        ..withCredentials = true;
    }

    dio.interceptors.add(DioErrorInterceptor());

    return dio;
  });
  // ==========================================================
  // API SERVICE
  // ==========================================================

  getIt.registerLazySingleton<ApiService>(
    () => ApiService(
      dio: getIt<Dio>(),
      cookieJar: getIt<CookieJar>(),
      refreshTokenUrl: kRefreshTokenUrl,
    ),
  );

  // ==========================================================
  // AUTH LOCAL DATA SOURCE
  // ==========================================================

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // ==========================================================
  // AUTH REMOTE DATA SOURCE
  // ==========================================================

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  // ==========================================================
  // AUTH REPOSITORY
  // ==========================================================

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: getIt<ApiService>(),
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // ==========================================================
  // AUTH USE CASES
  // ==========================================================

  getIt.registerLazySingleton<SignInUsecase>(
    () => SignInUsecase(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignUpUsecase>(
    () => SignUpUsecase(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogOutUseCase>(
    () => LogOutUseCase(authRepository: getIt<AuthRepository>()),
  );

  // ==========================================================
  // AUTH CUBITS
  // ==========================================================

  getIt.registerFactory<SignInCubit>(
    () => SignInCubit(signInUsecase: getIt<SignInUsecase>()),
  );

  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(signUpUsecase: getIt<SignUpUsecase>()),
  );

  getIt.registerFactory<SignOutCubit>(
    () => SignOutCubit(getIt<LogOutUseCase>()),
  );

  // ==========================================================
  // HOME DATA SOURCE
  // ==========================================================

  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  // ==========================================================
  // HOME REPOSITORY
  // ==========================================================

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepositoryImpl(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
      networkInfo: getIt<NetworkInfoImpl>(),
    ),
  );

  // ==========================================================
  // HOME USE CASES
  // ==========================================================

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

  getIt.registerLazySingleton<ChangeToIsFavourite>(
    () => ChangeToIsFavourite(homeRepo: getIt<HomeRepo>()),
  );

  getIt.registerLazySingleton<GetFavouriteProductsUseCase>(
    () => GetFavouriteProductsUseCase(getIt<HomeRepo>()),
  );

  // ==========================================================
  // HOME CUBITS
  // ==========================================================

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
      getBestSellingProductsUseCase: getIt<GetBestSellingProductUseCase>(),
      getNewestProductsUseCase: getIt<GetNewtestProductUseCase>(),
      changeToIsFavouriteUseCase: getIt<ChangeToIsFavourite>(),
      getFavoriteProductsUseCase: getIt<GetFavouriteProductsUseCase>(),
    ),
  );

  // ==========================================================
  // NOTIFICATION REPOSITORY
  // ==========================================================

  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt<ApiService>()),
  );

  // ==========================================================
  // NOTIFICATION USE CASES
  // ==========================================================

  getIt.registerLazySingleton<GetNotifications>(
    () => GetNotifications(getIt<NotificationRepository>()),
  );

  getIt.registerLazySingleton<MarkNotificationAsRead>(
    () => MarkNotificationAsRead(getIt<NotificationRepository>()),
  );

  getIt.registerLazySingleton<MarkNotificationAsFav>(
    () => MarkNotificationAsFav(getIt<NotificationRepository>()),
  );

  getIt.registerLazySingleton<GetUnReadNotifications>(
    () => GetUnReadNotifications(getIt<NotificationRepository>()),
  );

  getIt.registerLazySingleton<GetReadNotifications>(
    () => GetReadNotifications(getIt<NotificationRepository>()),
  );

  getIt.registerLazySingleton<GetFavNotifications>(
    () => GetFavNotifications(getIt<NotificationRepository>()),
  );

  getIt.registerLazySingleton<DeleteNotification>(
    () => DeleteNotification(getIt<NotificationRepository>()),
  );

  // ==========================================================
  // NOTIFICATION SERVICES
  // ==========================================================

  getIt.registerLazySingleton<SocketService>(() => SocketService());

  getIt.registerLazySingleton<FcmService>(() => FcmService());

  // ==========================================================
  // NOTIFICATION CUBIT
  // ==========================================================

  getIt.registerFactory<NotificationCubit>(
    () => NotificationCubit(
      getReadNotifications: getIt<GetReadNotifications>(),
      getFavNotifications: getIt<GetFavNotifications>(),
      getNotifications: getIt<GetNotifications>(),
      markNotificationAsRead: getIt<MarkNotificationAsRead>(),
      deleteNotificationUseCase: getIt<DeleteNotification>(),
      socketService: getIt<SocketService>(),
      markNotificationAsFav: getIt<MarkNotificationAsFav>(),
      getUnReadNotifications: getIt<GetUnReadNotifications>(),
    ),
  );

  // ==========================================================
  // SEARCH
  // ==========================================================

  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(getIt<SearchRemoteDataSource>()),
  );

  getIt.registerLazySingleton<SearchProductsUsecase>(
    () => SearchProductsUsecase(getIt<SearchRepository>()),
  );

  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(getIt<SearchProductsUsecase>()),
  );

  // ==========================================================
  // ORDER DATA SOURCE
  // ==========================================================

  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(getIt<ApiService>()),
  );

  // ==========================================================
  // ORDER REPOSITORY
  // ==========================================================

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(getIt<OrderRemoteDataSource>()),
  );

  // ==========================================================
  // ORDER USE CASES
  // ==========================================================

  getIt.registerLazySingleton<CreateOrderUseCase>(
    () => CreateOrderUseCase(getIt<OrderRepository>()),
  );

  getIt.registerLazySingleton<GetOrdersUseCase>(
    () => GetOrdersUseCase(getIt<OrderRepository>()),
  );

  // ==========================================================
  // ORDER CUBIT
  // ==========================================================

  getIt.registerFactory<OrderCubit>(
    () => OrderCubit(
      createOrderUseCase: getIt<CreateOrderUseCase>(),
      getOrdersUseCase: getIt<GetOrdersUseCase>(),
    ),
  );

  // ==========================================================
  // PRODUCT DETAILS
  // ==========================================================

  getIt.registerLazySingleton<ProductDetailsRemoteDataSource>(
    () => ProductDetailsRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepositoryImpl(getIt<ProductDetailsRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetProductDetailsUseCase>(
    () => GetProductDetailsUseCase(getIt<ProductDetailsRepository>()),
  );

  getIt.registerLazySingleton<AddProductReviewUseCase>(
    () => AddProductReviewUseCase(getIt<ProductDetailsRepository>()),
  );

  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(
      getProductDetailsUseCase: getIt<GetProductDetailsUseCase>(),
      addProductReviewUseCase: getIt<AddProductReviewUseCase>(),
    ),
  );

  // ==========================================================
  // CART
  // ==========================================================

  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(getIt<CartRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<UpdateCartItemQuantityUseCase>(
    () => UpdateCartItemQuantityUseCase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<RemoveAllFromCartUseCase>(
    () => RemoveAllFromCartUseCase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<ApplyCouponUseCase>(
    () => ApplyCouponUseCase(getIt<CartRepository>()),
  );

  getIt.registerFactory<CartCubit>(
    () => CartCubit(
      getCartUseCase: getIt<GetCartUseCase>(),
      addToCartUseCase: getIt<AddToCartUseCase>(),
      updateCartItemQuantityUseCase: getIt<UpdateCartItemQuantityUseCase>(),
      removeFromCartUseCase: getIt<RemoveFromCartUseCase>(),
      removeAllFromCartUseCase: getIt<RemoveAllFromCartUseCase>(),
      applyCouponUseCase: getIt<ApplyCouponUseCase>(),
    ),
  );

  // ==========================================================
  // ADDRESS
  // ==========================================================

  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://photon.komoot.io',
        headers: {
          'User-Agent': 'E-commerce/1.0 (contact: danyashraf012@example.com)',
          'Referer': 'https://github.com/Dany126/Bazar',
          'Accept': 'application/json',
          'Accept-Language': 'en',
        },
      ),
    ),
    instanceName: 'nominatimDio',
  );

  getIt.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSource(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<AddressRepo>(
    () => AddressRepoImpl(
      remoteDataSource: getIt<AddressRemoteDataSource>(),
      nominatimDio: getIt<Dio>(instanceName: 'nominatimDio'),
    ),
  );

  getIt.registerLazySingleton<GetCurrentLocationUseCase>(
    () => GetCurrentLocationUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<ReverseGeocodeUseCase>(
    () => ReverseGeocodeUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<AddAddressUseCase>(
    () => AddAddressUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<GetAddressesUseCase>(
    () => GetAddressesUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<DeleteAddressUseCase>(
    () => DeleteAddressUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<SetDefaultAddressUseCase>(
    () => SetDefaultAddressUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<EditAddressUseCase>(
    () => EditAddressUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<SearchPlacesUseCase>(
    () => SearchPlacesUseCase(getIt<AddressRepo>()),
  );

  getIt.registerFactory<AddressCubit>(
    () => AddressCubit(
      getCurrentLocationUseCase: getIt<GetCurrentLocationUseCase>(),
      reverseGeocodeUseCase: getIt<ReverseGeocodeUseCase>(),
      addAddressUseCase: getIt<AddAddressUseCase>(),
      getAddressesUseCase: getIt<GetAddressesUseCase>(),
      deleteAddressUseCase: getIt<DeleteAddressUseCase>(),
      setDefaultAddressUseCase: getIt<SetDefaultAddressUseCase>(),
      editAddressUseCase: getIt<EditAddressUseCase>(),
      searchPlacesUseCase: getIt<SearchPlacesUseCase>(),
    ),
  );

  // ==========================================================
  // PAYMENT METHOD
  // ==========================================================

  getIt.registerLazySingleton<PaymentLocalDataSource>(
    () => PaymentLocalDataSource(),
  );

  getIt.registerLazySingleton<PaymentRepo>(
    () => PaymentRepoImpl(getIt<PaymentLocalDataSource>()),
  );

  getIt.registerLazySingleton<GetSavedCardsUseCase>(
    () => GetSavedCardsUseCase(getIt<PaymentRepo>()),
  );

  getIt.registerLazySingleton<AddCardUseCase>(
    () => AddCardUseCase(getIt<PaymentRepo>()),
  );

  getIt.registerLazySingleton<RemoveCardUseCase>(
    () => RemoveCardUseCase(getIt<PaymentRepo>()),
  );

  getIt.registerFactory<PaymentCubit>(
    () => PaymentCubit(
      getSavedCardsUseCase: getIt<GetSavedCardsUseCase>(),
      addCardUseCase: getIt<AddCardUseCase>(),
      removeCardUseCase: getIt<RemoveCardUseCase>(),
    ),
  );

  // ==========================================================
  // PAYMOB
  // ==========================================================

  getIt.registerLazySingleton<PaymobRemoteDataSource>(
    () => PaymobRemoteDataSource(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<PaymobRepository>(
    () => PaymobRepositoryImpl(getIt<PaymobRemoteDataSource>()),
  );

  getIt.registerLazySingleton<CreatePaymobPaymentUseCase>(
    () => CreatePaymobPaymentUseCase(getIt<PaymobRepository>()),
  );

  // ==========================================================
  // CHECKOUT
  // ==========================================================

  getIt.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(
      getAddressesUseCase: getIt<GetAddressesUseCase>(),
      getSavedCardsUseCase: getIt<GetSavedCardsUseCase>(),
    ),
  );

  // ==========================================================
  // REVIEWS
  // ==========================================================

  getIt.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSource(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<ReviewRepository>(
    () =>
        ReviewRepositoryImpl(remoteDataSource: getIt<ReviewRemoteDataSource>()),
  );

  getIt.registerFactory<ReviewCubit>(
    () => ReviewCubit(repository: getIt<ReviewRepository>()),
  );

  // ==========================================================
  // ADMIN
  // ==========================================================

  // ==========================================================
  // ADMIN DASHBOARD
  // ==========================================================

  getIt.registerLazySingleton<AdminDashboardRemoteDataSource>(
    () => AdminDashboardRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<AdminDashboardRepository>(
    () => AdminDashboardRepositoryImpl(
      remoteDataSource: getIt<AdminDashboardRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetAdminDashboardDataUseCase>(
    () => GetAdminDashboardDataUseCase(getIt<AdminDashboardRepository>()),
  );

  getIt.registerFactory<AdminDashboardCubit>(
    () => AdminDashboardCubit(
      getAdminDashboardDataUseCase: getIt<GetAdminDashboardDataUseCase>(),
    ),
  );

  // ==========================================================
  // ADMIN PRODUCTS
  // ==========================================================

  getIt.registerLazySingleton<AdminProductRemoteDataSource>(
    () => AdminProductRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<AdminProductRepository>(
    () => AdminProductRepositoryImpl(
      remoteDataSource: getIt<AdminProductRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetAllAdminProductsUseCase>(
    () => GetAllAdminProductsUseCase(getIt<AdminProductRepository>()),
  );

  getIt.registerLazySingleton<CreateAdminProductUseCase>(
    () => CreateAdminProductUseCase(getIt<AdminProductRepository>()),
  );

  getIt.registerLazySingleton<UpdateAdminProductUseCase>(
    () => UpdateAdminProductUseCase(getIt<AdminProductRepository>()),
  );

  getIt.registerLazySingleton<DeleteAdminProductUseCase>(
    () => DeleteAdminProductUseCase(getIt<AdminProductRepository>()),
  );

  getIt.registerFactory<AdminProductsCubit>(
    () => AdminProductsCubit(
      getAllProductsUseCase: getIt<GetAllAdminProductsUseCase>(),
      createProductUseCase: getIt<CreateAdminProductUseCase>(),
      updateProductUseCase: getIt<UpdateAdminProductUseCase>(),
      deleteProductUseCase: getIt<DeleteAdminProductUseCase>(),
    ),
  );

  // ==========================================================
  // ADMIN USERS
  // ==========================================================

  getIt.registerLazySingleton<AdminUsersRemoteDataSource>(
    () => AdminUsersRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<AdminUsersRepository>(
    () => AdminUsersRepositoryImpl(
      remoteDataSource: getIt<AdminUsersRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetAdminUsersUseCase>(
    () => GetAdminUsersUseCase(getIt<AdminUsersRepository>()),
  );

  getIt.registerFactory<AdminUsersCubit>(
    () => AdminUsersCubit(useCase: getIt<GetAdminUsersUseCase>()),
  );
}
