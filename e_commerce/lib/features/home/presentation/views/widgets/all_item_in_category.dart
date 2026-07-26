import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_card.dart';
import 'package:flutter/material.dart';

class AllItemsInCategoryView extends StatefulWidget {
  const AllItemsInCategoryView({super.key});

  static const routeName = 'AllItemsInCategory';

  @override
  State<AllItemsInCategoryView> createState() => _AllItemsInCategoryViewState();
}

class _AllItemsInCategoryViewState extends State<AllItemsInCategoryView> {
  @override
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final category = args['category'] as CategoryEntity;
    final products = args['products'] as List<ProductEntity>;

    return Scaffold(
      appBar: customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                "${category.name} ( ${products.length} )",
                style: AppStyles.textStylesSemiBold24(context),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverGrid.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.5,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: products[index], onTap: () {});
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}
