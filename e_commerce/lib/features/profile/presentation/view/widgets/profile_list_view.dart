import 'package:e_commerce/features/profile/domain/entity/profile_item_entity.dart';
import 'package:e_commerce/features/profile/presentation/view/widgets/profile_item.dart';
import 'package:flutter/material.dart';

class ProfileListView extends StatelessWidget {
  ProfileListView({super.key});

  final List<ProfileItemEntity> items = [
    ProfileItemEntity(title: "Address", onTap: () {}),
    ProfileItemEntity(title: "My Favorites", onTap: () {}),
    ProfileItemEntity(title: "Payment", onTap: () {}),
    ProfileItemEntity(title: "Help", onTap: () {}),
    ProfileItemEntity(title: "Support", onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: items.length,

      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },

      itemBuilder: (context, index) {
        return ProfileItem(profileItemEntity: items[index]);
      },
    );
  }
}
