import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.title});
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 48,
      leadingWidth: 42,
      leading: const CustomBackButton(),
      centerTitle: true,
      title: Text(title ?? '', style: AppStyles.textStylesSemiBold20(context)),
      actions: const [SizedBox(width: 42)],
    );
  }
}
