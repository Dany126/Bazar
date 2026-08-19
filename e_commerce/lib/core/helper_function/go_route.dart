import 'package:e_commerce/features/address/presentation/views/address_view.dart';
import 'package:e_commerce/features/address/presentation/views/map_view.dart';
import 'package:e_commerce/features/auth/presentation/view/reset_password_view.dart';
import 'package:e_commerce/features/auth/presentation/view/sign_in_view.dart';
import 'package:e_commerce/features/auth/presentation/view/signup_view.dart';
import 'package:e_commerce/features/cart/presentation/view/cart_view.dart';
import 'package:e_commerce/features/checkout/presentation/views/checkout_view.dart';
import 'package:e_commerce/features/home/presentation/views/category_details_view.dart';
import 'package:e_commerce/features/home/presentation/views/home_view.dart';

import 'package:e_commerce/features/home/presentation/views/widgets/all_item_in_category.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/new_arrivals.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/top_selling.dart';
import 'package:e_commerce/features/notification/presentation/view/notification_view.dart';
import 'package:e_commerce/features/order/presenation/view/order_view.dart';
import 'package:e_commerce/features/product_details/presentation/views/product_details_view.dart';
import 'package:e_commerce/features/profile/presentation/view/profile_view.dart';
import 'package:e_commerce/features/search/presentation/views/search_view.dart';
import 'package:e_commerce/features/splash/presentation/view/splash_view.dart';
import 'package:e_commerce/main_view.dart';
import 'package:flutter/material.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());

    case SignInView.routeName:
      return MaterialPageRoute(builder: (context) => const SignInView());

    case SignUpView.routeName:
      return MaterialPageRoute(builder: (context) => const SignUpView());

    case ResetPasswordView.routeName:
      return MaterialPageRoute(builder: (context) => const ResetPasswordView());

    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());

    case CategoryDetailsView.routeName:
      return MaterialPageRoute(
        builder: (context) => const CategoryDetailsView(),
      );

    case AllItemsInCategoryView.routeName:
      return MaterialPageRoute(
        settings: settings, // ⭐ IMPORTANT
        builder: (context) => const AllItemsInCategoryView(),
      );

    case NotificationView.routeName:
      return MaterialPageRoute(builder: (context) => const NotificationView());

    case MainView.routeName:
      return MaterialPageRoute(builder: (context) => const MainView());
    case OrderView.routeName:
      return MaterialPageRoute(builder: (context) => const OrderView());
    case TopSelling.routeName:
      return MaterialPageRoute(builder: (context) => const TopSelling());

    case NewArrivals.routeName:
      return MaterialPageRoute(builder: (context) => const NewArrivals());

    case SearchView.routeName:
      return MaterialPageRoute(builder: (context) => const SearchView());

    case ProductDetailsView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const ProductDetailsView(),
      );
    case CartView.routeName:
      return MaterialPageRoute(builder: (context) => const CartView());

    case ProfileView.routeName:
      return MaterialPageRoute(builder: (context) => const ProfileView());
    case CheckoutView.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const CheckoutView(),
      );
    case AddressView.routeName:
      return MaterialPageRoute(builder: (context) => const AddressView());

    case MapView.routeName:
      return MaterialPageRoute(builder: (context) => const MapView());

    default:
      return MaterialPageRoute(
        builder: (context) =>
            const Scaffold(body: Center(child: Text('Screen does not exist!'))),
      );
  }
}
