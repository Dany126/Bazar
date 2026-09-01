import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Branding Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.storefront, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Marketplace',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Main Navigation
          const _SidebarSection(title: 'MAIN'),
          _SidebarItem(
            icon: Icons.dashboard_rounded,
            title: 'Dashboard',
            isActive: selectedIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          _SidebarItem(
            icon: Icons.pie_chart_rounded,
            title: 'Overview',
            isActive: selectedIndex == 1,
            onTap: () => onItemSelected(1),
          ),
          _SidebarItem(
            icon: Icons.people_alt_rounded,
            title: 'Customers',
            isActive: selectedIndex == 2,
            onTap: () => onItemSelected(2),
          ),
          _SidebarItem(
            icon: Icons.inventory_2_rounded,
            title: 'Products',
            isActive: selectedIndex == 3,
            onTap: () => onItemSelected(3),
          ),
          _SidebarItem(
            icon: Icons.work_rounded,
            title: 'Workspace',
            isActive: selectedIndex == 4,
            onTap: () => onItemSelected(4),
          ),
          _SidebarItem(
            icon: Icons.settings_rounded,
            title: 'Settings',
            isActive: selectedIndex == 5,
            onTap: () => onItemSelected(5),
          ),

          const SizedBox(height: 24),
          const _SidebarSection(title: 'FINANCE'),
          _SidebarItem(
            icon: Icons.account_balance_wallet_rounded,
            title: 'Earnings',
            isActive: selectedIndex == 6,
            onTap: () => onItemSelected(6),
          ),
          _SidebarItem(
            icon: Icons.payments_rounded,
            title: 'Payouts',
            isActive: selectedIndex == 7,
            onTap: () => onItemSelected(7),
          ),

          const Spacer(),
          // Logout or Profile section could go here
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  const _SidebarSection({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.kSecondaryTextColor,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.title,
    this.isActive = false,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.kPrimaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isActive
                        ? AppColors.kPrimaryColor
                        : AppColors.kSecondaryTextColor,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isActive
                              ? AppColors.kPrimaryColor
                              : AppColors.kSecondaryTextColor,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                  const Spacer(),
                  if (isActive)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
