import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_user.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminWorkspaceView extends StatelessWidget {
  const AdminWorkspaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminUsersCubit>()..load(),
      child: const _WorkspaceBody(),
    );
  }
}

class _WorkspaceBody extends StatelessWidget {
  const _WorkspaceBody();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<AdminUsersCubit>().load(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workspace',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Administrators',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            BlocBuilder<AdminUsersCubit, AdminUsersState>(
              builder: (context, state) {
                if (state is AdminUsersInitial || state is AdminUsersLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is AdminUsersFailure) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () {
                      context.read<AdminUsersCubit>().load();
                    },
                  );
                }

                if (state is AdminUsersLoaded) {
                  final admins = state.users
                      .where((user) => user.role.toLowerCase() == 'admin')
                      .toList();

                  if (admins.isEmpty) {
                    return const _EmptyState();
                  }

                  return Card(
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: admins.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return _AdminTile(admin: admins[index]);
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final AdminUser admin;

  const _AdminTile({required this.admin});

  @override
  Widget build(BuildContext context) {
    final name = admin.name.trim();
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
        child: Text(
          initial,
          style: const TextStyle(
            color: AppColors.kPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        name.isEmpty ? 'No name' : name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(admin.email.isEmpty ? 'No email' : admin.email),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Admin',
          style: TextStyle(
            color: AppColors.kPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.admin_panel_settings_outlined,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No administrators found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
