import 'package:cookie_jar/cookie_jar.dart';
import 'package:e_commerce/dashboard/dashboard_demo_app.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
// import 'package:e_commerce/features/search/presentation/views/search_view.dart';
import 'package:e_commerce/features/splash/presentation/view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:e_commerce/core/helper_function/go_route.dart';
import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/core/notifications/fcm_service.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_theme.dart';
import 'package:e_commerce/firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // ==========================================================
//   // FIREBASE
//   // ==========================================================

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Background FCM handler
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   // ==========================================================
//   // SHARED PREFERENCES
//   // ==========================================================
//   await Hive.initFlutter();
//   await Hive.openBox('authBox');
//   await SharedPrefsHelper.init();

//   // ==========================================================
//   // COOKIE STORAGE
//   // ==========================================================

//   final appDirectory = await getApplicationDocumentsDirectory();

//   final cookieDirectory = '${appDirectory.path}/cookies';

//   debugPrint('COOKIE DIRECTORY: $cookieDirectory');

//   final cookieJar = PersistCookieJar(storage: FileStorage(cookieDirectory));

//   // ==========================================================
//   // GET IT
//   // ==========================================================

//   await setupServiceLocator(cookieJar: cookieJar);

//   // ==========================================================
//   // RESTORE SESSION
//   // ==========================================================

//   final apiService = getIt<ApiService>();

//   await apiService.restoreSession();

//   // ==========================================================
//   // FCM
//   // ==========================================================

//   final fcmService = FcmService(
//     onNotificationTap: (data) {
//       debugPrint('NOTIFICATION TAP DATA: $data');

//       // You can navigate here later.
//       //
//       // Example:
//       // final orderId = data['orderId'];
//       // navigatorKey.currentState?.pushNamed(...);
//     },
//     onForegroundMessage: (data) {
//       debugPrint('FOREGROUND NOTIFICATION DATA: $data');
//     },
//   );

//   await fcmService.init();

//   // ==========================================================
//   // TOKEN REFRESH
//   // ==========================================================

//   fcmService.onTokenRefresh((token) async {
//     debugPrint('NEW FCM TOKEN: $token');

//     // IMPORTANT:
//     // Send this token to your Express backend.
//     //
//     // await registerDeviceToken(token);
//   });

//   // ==========================================================
//   // START APP
//   // ==========================================================

//   runApp(
//     BlocProvider<CartCubit>(
//       create: (context) => getIt<CartCubit>(),
//       child: const Bazar(),
//     ),
//   );
// }

void main() {
  runApp(const DashboardDemoApp());
}

class Bazar extends StatelessWidget {
  const Bazar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
      initialRoute: SplashView.routeName,
    );
  }
}
