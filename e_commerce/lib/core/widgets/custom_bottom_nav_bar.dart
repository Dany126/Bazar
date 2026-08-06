import 'package:e_commerce/core/utils/assets.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavIcon(
            icon: Image.asset(Assets.assetsImagesInActiveHome),
            activeIcon: Image.asset(Assets.assetsImagesActiveHome),
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavIcon(
            icon: Image.asset(Assets.assetsImagesInActivenotificationbing),
            activeIcon: Image.asset(Assets.assetsImagesActivenotificationbing),
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavIcon(
            icon: Image.asset(Assets.assetsImagesInActiveReceipt),
            activeIcon: Image.asset(Assets.assetsImagesActiveReceipt),
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavIcon(
            icon: Image.asset(Assets.assetsImagesInActiveprofile),
            activeIcon: Image.asset(Assets.assetsImagesActiveprofile),
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
  });

  final Image icon;
  final Image activeIcon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        scale: isActive ? 1.15 : 1,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: SizedBox(
            key: ValueKey(isActive),
            child: isActive ? activeIcon : icon,
          ),
        ),
      ),
    );
  }
}
