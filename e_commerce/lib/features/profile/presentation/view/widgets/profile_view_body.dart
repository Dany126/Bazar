import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/auth/presentation/view/sign_in_view.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_out/cubit/sign_out_cubit.dart';
import 'package:e_commerce/features/profile/presentation/view/widgets/profile_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignOutCubit, SignOutState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          Navigator.pushReplacementNamed(context, SignInView.routeName);
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

              const Center(
                child: Image(
                  image: AssetImage(Assets.assetsImagesProfile),
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),

              const SizedBox(height: 20),

              Container(
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
                    "John Doe",
                    style: AppStyles.textStylesSemiBold18(context),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "gilbertjones001@gmail.com",
                      style: AppStyles.textStylesRegular16(
                        context,
                      ).copyWith(color: const Color(0xff7F7F7F)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ProfileListView(),

              const SizedBox(height: 30),

              state is SignOutSuccess || state is SignOutFailure
                  ? const SizedBox.shrink()
                  : SizedBox(
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
                          "Sign Out",
                          style: AppStyles.textStylesSemiBold18(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                    ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
