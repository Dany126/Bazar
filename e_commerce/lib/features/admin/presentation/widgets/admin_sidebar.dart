import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/auth/presentation/view/sign_in_view.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_out/cubit/sign_out_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return SizedBox(
      width: 250,
      height: double.infinity,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

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
                      child: const Icon(
                        Icons.storefront,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bazar',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _SidebarSection(title: 'MAIN'),

                      _SidebarItem(
                        icon: Icons.dashboard_rounded,
                        title: 'Dashboard',
                        isActive: selectedIndex == 0,
                        onTap: () => onItemSelected(0),
                      ),

                      _SidebarItem(
                        icon: Icons.people_alt_rounded,
                        title: 'Customers',
                        isActive: selectedIndex == 1,
                        onTap: () => onItemSelected(1),
                      ),

                      _SidebarItem(
                        icon: Icons.inventory_2_rounded,
                        title: 'Products',
                        isActive: selectedIndex == 2,
                        onTap: () => onItemSelected(2),
                      ),

                      _SidebarItem(
                        icon: Icons.category_rounded,
                        title: 'Categories',
                        isActive: selectedIndex == 3,
                        onTap: () => onItemSelected(3),
                      ),

                      _SidebarItem(
                        icon: Icons.shopping_bag_rounded,
                        title: 'Orders',
                        isActive: selectedIndex == 4,
                        onTap: () => onItemSelected(4),
                      ),

                      _SidebarItem(
                        icon: Icons.work_rounded,
                        title: 'Workspace',
                        isActive: selectedIndex == 5,
                        onTap: () => onItemSelected(5),
                      ),

                      _SidebarItem(
                        icon: Icons.settings_rounded,
                        title: 'Settings',
                        isActive: selectedIndex == 6,
                        onTap: () => onItemSelected(6),
                      ),

                      const SizedBox(height: 16),

                      const _SidebarSection(title: 'FINANCE'),

                      _SidebarItem(
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'Earnings',
                        isActive: selectedIndex == 7,
                        onTap: () => onItemSelected(7),
                      ),

                      _SidebarItem(
                        icon: Icons.payments_rounded,
                        title: 'Payouts',
                        isActive: selectedIndex == 8,
                        onTap: () => onItemSelected(8),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              const Divider(height: 1, color: Color(0xffE8EAF0)),

              const SizedBox(height: 12),

              BlocProvider(
                create: (_) => getIt<SignOutCubit>(),
                child: const _LogoutButton(),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignOutCubit, SignOutState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            SignInView.routeName,
            (route) => false,
          );
        }

        if (state is SignOutFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.failure.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is SignOutLoading;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<SignOutCubit>().signOut();
                    },
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.logout),
              label: Text(isLoading ? 'Signing out...' : 'Sign Out'),
            ),
          ),
        );
      },
    );
  }
}

class _SidebarSection extends StatelessWidget {
  const _SidebarSection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
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
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isActive
                            ? AppColors.kPrimaryColor
                            : AppColors.kSecondaryTextColor,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isActive)
                    Container(
                      width: 5,
                      height: 5,
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
