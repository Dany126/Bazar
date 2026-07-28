import 'package:e_commerce/core/helper_function/go_route.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_theme.dart';
// import 'package:e_commerce/features/home/presentation/views/home_view.dart';

import 'package:e_commerce/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  runApp(const Bazar());
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
