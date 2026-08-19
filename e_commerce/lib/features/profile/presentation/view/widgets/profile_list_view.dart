import 'package:e_commerce/features/address/presentation/views/address_view.dart';
import 'package:e_commerce/features/profile/domain/entity/profile_item_entity.dart';
import 'package:e_commerce/features/profile/presentation/view/my_favourite_view.dart';
import 'package:e_commerce/features/profile/presentation/view/widgets/profile_item.dart';
import 'package:flutter/material.dart';

class ProfileListView extends StatelessWidget {
  const ProfileListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProfileItemEntity> items = [
      ProfileItemEntity(
        title: "Address",
        onTap: () {
          Navigator.pushNamed(context, AddressView.routeName);
        },
      ),
      ProfileItemEntity(
        title: "My Favorites",
        onTap: () {
          Navigator.pushNamed(context, MyFavouriteView.routeName);
        },
      ),
      ProfileItemEntity(title: "Payment", onTap: () {}),
      ProfileItemEntity(title: "Help", onTap: () {}),
      ProfileItemEntity(title: "Support", onTap: () {}),
    ];

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
