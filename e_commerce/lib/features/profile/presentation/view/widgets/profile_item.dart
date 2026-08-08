import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/profile/domain/entity/profile_item_entity.dart';
import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({super.key, required this.profileItemEntity});
  final ProfileItemEntity profileItemEntity;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: profileItemEntity.onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.kSecondaryAccentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            children: [
              Text(
                profileItemEntity.title,
                style: AppStyles.textStylesRegular16(context),
              ),
              Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
