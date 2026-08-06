import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
            icon: Iconsax.home,
            activeIcon: Iconsax.home_1,
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavIcon(
            icon: Iconsax.notification,
            activeIcon: Iconsax.notification5,
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavIcon(
            icon: Iconsax.receipt_text,
            activeIcon: Iconsax.receipt_text5,
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavIcon(
            icon: Iconsax.profile_circle,
            activeIcon: Iconsax.profile_circle5,
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

  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Icon(
          isActive ? activeIcon : icon,
          size: 26,
          color: isActive
              ? AppColors.kPrimaryColor
              : AppColors.kSecondaryTextColor,
        ),
      ),
    );
  }
}
