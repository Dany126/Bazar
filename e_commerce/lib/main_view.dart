import 'package:e_commerce/core/widgets/custom_bottom_nav_bar.dart';
import 'package:e_commerce/features/home/presentation/views/home_view.dart';
import 'package:e_commerce/features/notification/presentation/view/notification_view.dart';
import 'package:e_commerce/features/order/presenation/view/order_view.dart';
import 'package:e_commerce/features/profile/presentation/view/profile_view.dart';

import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const routeName = 'main';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeView(),
    NotificationView(),
    OrderView(),
    ProfileView(),
  ];

  @override
/*************  ✨ Windsurf Command ⭐  *************/
/// Builds the widget tree for the [MainView].
///
/// It uses a [Scaffold] widget as the root of the tree and a

/*******  40199105-da8f-45e7-98a6-30a3174ced48  *******/
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
