import 'package:cookie_jar/cookie_jar.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
// import 'package:e_commerce/features/search/presentation/views/search_view.dart';
import 'package:e_commerce/features/splash/presentation/view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==========================================================
  // FIREBASE
  // ==========================================================

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Background FCM handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // ==========================================================
  // SHARED PREFERENCES
  // ==========================================================
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await SharedPrefsHelper.init();

  // ==========================================================
  // COOKIE STORAGE
  // ==========================================================

  late CookieJar cookieJar;

  if (kIsWeb) {
    // Web: Use in-memory cookie jar
    cookieJar = CookieJar();
  } else {
    // Native: Use persistent cookie jar
    final appDirectory = await getApplicationDocumentsDirectory();
    final cookieDirectory = '${appDirectory.path}/cookies';
    debugPrint('COOKIE DIRECTORY: $cookieDirectory');
    cookieJar = PersistCookieJar(storage: FileStorage(cookieDirectory));
  }

  // ==========================================================
  // GET IT
  // ==========================================================

  await setupServiceLocator(cookieJar: cookieJar);

  // ==========================================================
  // RESTORE SESSION
  // ==========================================================

  final apiService = getIt<ApiService>();

  await apiService.restoreSession();

  // ==========================================================
  // FCM
  // ==========================================================

  final fcmService = FcmService(
    onNotificationTap: (data) {
      debugPrint('NOTIFICATION TAP DATA: $data');

      // You can navigate here later.
      //
      // Example:
      // final orderId = data['orderId'];
      // navigatorKey.currentState?.pushNamed(...);
    },
    onForegroundMessage: (data) {
      debugPrint('FOREGROUND NOTIFICATION DATA: $data');
    },
  );

  await fcmService.init();

  // ==========================================================
  // TOKEN REFRESH
  // ==========================================================

  fcmService.onTokenRefresh((token) async {
    debugPrint('NEW FCM TOKEN: $token');

    // IMPORTANT:
    // Send this token to your Express backend.
    //
    // await registerDeviceToken(token);
  });

  // ==========================================================
  // START APP
  // ==========================================================

  runApp(
    BlocProvider<CartCubit>(
      create: (context) => getIt<CartCubit>(),
      child: const Bazar(),
    ),
  );
}

// void main() {
//   runApp(const DashboardDemoApp());
// }

class Bazar extends StatefulWidget {
  const Bazar({super.key});

  @override
  State<Bazar> createState() => _BazarState();
}

class _BazarState extends State<Bazar> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return CustomerThemeScope(
      themeMode: _themeMode,
      onToggle: () => setState(() {
        _themeMode = _themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
      }),
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoute,
        initialRoute: SplashView.routeName,
      ),
    );
  }
}

class CustomerThemeScope extends InheritedWidget {
  const CustomerThemeScope({
    super.key,
    required this.themeMode,
    required this.onToggle,
    required super.child,
  });

  final ThemeMode themeMode;
  final VoidCallback onToggle;

  static CustomerThemeScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CustomerThemeScope>()!;
  }

  @override
  bool updateShouldNotify(CustomerThemeScope oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}
// i need to make domain layer and data layer to make it real dashboard with out edit in backend i need integrate the  end point exist in server