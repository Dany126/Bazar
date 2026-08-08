import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';

import 'package:e_commerce/core/utils/app_colors.dart';

import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/auth/presentation/view/sign_in_view.dart';
import 'package:e_commerce/main_view.dart';
import 'package:flutter/material.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // We'll set the real range in didChangeDependencies once we know screen width
    _translateAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));

    navigation(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;

    _translateAnimation = Tween<double>(
      begin: -screenWidth,
      end: 0.0, // centered
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.kPrimaryColor),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.translate(
          offset: Offset(_translateAnimation.value, 0.0),
          child: Center(
            child: Image.asset(
              Assets.assetsImagesLogo,
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  void navigation(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    final loggedIn = SharedPrefsHelper.isLoggedIn();

    if (context.mounted) {
      if (loggedIn) {
        Navigator.pushReplacementNamed(context, MainView.routeName);
      } else {
        Navigator.pushReplacementNamed(context, SignInView.routeName);
      }
    }
  }
}
