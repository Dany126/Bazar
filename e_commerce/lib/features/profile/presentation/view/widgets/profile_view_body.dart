import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/auth/presentation/view/sign_in_view.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_out/cubit/sign_out_cubit.dart';
import 'package:e_commerce/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e_commerce/features/profile/presentation/cubit/profile_state.dart';
import 'package:e_commerce/features/profile/presentation/view/profile_details_view.dart';
import 'package:e_commerce/features/profile/presentation/view/widgets/profile_list_view.dart';
import 'package:e_commerce/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  @override
  void initState() {
    super.initState();

    getIt<ProfileCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, profileState) {
          if (profileState is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(profileState.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, profileState) {
          UserEntity? user;

          if (profileState is ProfileLoaded) {
            user = profileState.user;
          }

          if (profileState is ProfileUpdating) {
            user = profileState.user;
          }

          if (profileState is ProfileUpdated) {
            user = profileState.user;
          }

          if (user == null) {
            if (profileState is ProfileFailure) {
              return _buildNoUserView(context, profileState.message);
            }

            return const Center(child: CircularProgressIndicator());
          }

          return _buildProfileView(context, user);
        },
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, UserEntity user) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 30),

              _buildProfileAvatar(user),

              const SizedBox(height: 20),

              _buildUserCard(context, user),

              const SizedBox(height: 20),

              ProfileListView(),

              const SizedBox(height: 12),

              _buildThemeTile(context),

              const SizedBox(height: 30),

              if (state is! SignOutSuccess && state is! SignOutFailure)
                _buildSignOutButton(context),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileAvatar(UserEntity user) {
    final imageUrl = user.imageUrl?.trim();

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar(user);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const SizedBox(
              width: 100,
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      );
    }

    return _buildDefaultAvatar(user);
  }

  Widget _buildDefaultAvatar(UserEntity user) {
    final name = user.name.trim();

    if (name.isEmpty) {
      return const ClipOval(
        child: Image(
          image: AssetImage(Assets.assetsImagesProfile),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.kPrimaryColor,
      ),
      alignment: Alignment.center,
      child: Text(
        name.substring(0, 1).toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserEntity user) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.kSecondaryAccentColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        title: Text(
          user.name.isEmpty ? 'User' : user.name,
          style: AppStyles.textStylesSemiBold18(context),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email.isEmpty ? 'No email' : user.email,
                style: AppStyles.textStylesRegular16(
                  context,
                ).copyWith(color: const Color(0xff7F7F7F)),
              ),
              if (user.phone.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  user.phone,
                  style: AppStyles.textStylesRegular16(
                    context,
                  ).copyWith(color: const Color(0xff7F7F7F)),
                ),
              ],
            ],
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ProfileDetailsView(
                    initialName: user.name,
                    initialEmail: user.email,
                    initialPhone: user.phone,
                    initialImageUrl: user.imageUrl,
                  );
                },
              ),
            );
          },
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Edit profile',
        ),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(
        CustomerThemeScope.of(context).themeMode == ThemeMode.dark
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
      ),
      title: const Text('Dark mood'),
      trailing: Switch(
        value: CustomerThemeScope.of(context).themeMode == ThemeMode.dark,
        onChanged: (_) {
          CustomerThemeScope.of(context).onToggle();
        },
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<SignOutCubit>().signOut();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Sign Out',
          style: AppStyles.textStylesSemiBold18(
            context,
          ).copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildNoUserView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off_outlined, size: 70, color: Colors.grey),

            const SizedBox(height: 16),

            Text(
              'User information not found',
              textAlign: TextAlign.center,
              style: AppStyles.textStylesSemiBold18(context),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.textStylesRegular16(
                context,
              ).copyWith(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInView.routeName,
                  (route) => false,
                );
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
