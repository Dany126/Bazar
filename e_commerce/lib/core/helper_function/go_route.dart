import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/views/add_address_view.dart';
import 'package:e_commerce/features/address/presentation/views/address_view.dart';
import 'package:e_commerce/features/address/presentation/views/map_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_dashboard_view.dart';
import 'package:e_commerce/features/auth/presentation/view/reset_password_view.dart';
import 'package:e_commerce/features/auth/presentation/view/sign_in_view.dart';
import 'package:e_commerce/features/auth/presentation/view/signup_view.dart';
import 'package:e_commerce/features/cart/presentation/view/cart_view.dart';
import 'package:e_commerce/features/checkout/presentation/views/checkout_view.dart';
import 'package:e_commerce/features/home/presentation/views/category_details_view.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/views/home_view.dart';

import 'package:e_commerce/features/home/presentation/views/widgets/all_item_in_category.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/new_arrivals.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/top_selling.dart';
import 'package:e_commerce/features/notification/presentation/view/notification_view.dart';
import 'package:e_commerce/features/order/presenation/view/order_view.dart';
import 'package:e_commerce/features/payment_method/presentation/model_view/cubit/payment_cubit.dart';
import 'package:e_commerce/features/payment_method/presentation/views/payment_methods_view.dart';
import 'package:e_commerce/features/product_details/presentation/views/product_details_view.dart';
import 'package:e_commerce/features/profile/presentation/view/my_favourite_view.dart';
import 'package:e_commerce/features/profile/presentation/view/profile_view.dart';
import 'package:e_commerce/features/search/presentation/views/search_view.dart';
import 'package:e_commerce/features/splash/presentation/view/splash_view.dart';
import 'package:e_commerce/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    case AdminDashboardView.routeName:
      return MaterialPageRoute(
        builder: (context) => const AdminDashboardView(),
      );
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
      return MaterialPageRoute(
        builder: (context) => BlocProvider<AddressCubit>(
          create: (_) => getIt<AddressCubit>(),
          child: const MapView(),
        ),
      );

    case AddAddressView.routeName:
      return MaterialPageRoute(
        builder: (context) => BlocProvider<AddressCubit>(
          create: (_) => getIt<AddressCubit>(),
          child: const AddAddressView(),
        ),
      );

    case MyFavouriteView.routeName:
      return MaterialPageRoute(
        builder: (context) => BlocProvider<GetProductsCubit>(
          create: (_) => getIt<GetProductsCubit>(),
          child: const MyFavouriteView(),
        ),
      );

    case PaymentMethodsView.routeName:
      return MaterialPageRoute(
        builder: (context) => BlocProvider<PaymentCubit>(
          create: (_) => getIt<PaymentCubit>(),
          child: const PaymentMethodsView(),
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) =>
            const Scaffold(body: Center(child: Text('Screen does not exist!'))),
      );
  }
}
