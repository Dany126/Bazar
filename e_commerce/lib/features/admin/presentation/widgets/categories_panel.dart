import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPanel extends StatelessWidget {
  const CategoriesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE8EAF0)),
      ),
      child: BlocBuilder<AdminCategoriesCubit, AdminCategoriesState>(
        builder: (context, state) {
          if (state is AdminCategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminCategoriesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (state is! AdminCategoriesLoaded) {
            return const Center(
              child: Text(
                'No categories',
                style: TextStyle(color: Color(0xff777B8C)),
              ),
            );
          }

          if (state.categories.isEmpty) {
            return const Center(
              child: Text(
                'No categories found',
                style: TextStyle(color: Color(0xff777B8C)),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff20222F),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  primary: false,
                  itemCount: state.categories.length,
                  separatorBuilder: (_, __) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    final category = state.categories[index];

                    return CategoryCard(
                      category: category,
                      selected: state.selectedCategoryId == category.id,
                      onTap: () {
                        context.read<AdminCategoriesCubit>().selectCategory(
                          category,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
