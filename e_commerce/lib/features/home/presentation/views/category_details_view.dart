import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/category_details_view_body.dart';
import 'package:flutter/material.dart';

class CategoryDetailsView extends StatelessWidget {
  const CategoryDetailsView({super.key});
  static const routeName = 'CategoryDetailsViewBody';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: CategoryDetailsViewBody(),
      ),
    );
  }
}
