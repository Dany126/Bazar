import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/widgets/categories_panel.dart';
import 'package:e_commerce/features/admin/presentation/widgets/products_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCategoriesView extends StatelessWidget {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminCategoriesCubit>()..loadCategories(),
      child: const _AdminCategoriesBody(),
    );
  }
}

class _AdminCategoriesBody extends StatelessWidget {
  const _AdminCategoriesBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              if (width < 900) {
                return const _MobileLayout();
              }

              return const _DesktopLayout();
            },
          ),
        ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 330, child: const CategoriesPanel()),

          const SizedBox(width: 24),

          const Expanded(child: ProductsPanel()),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 420, child: const CategoriesPanel()),

            const SizedBox(height: 24),

            SizedBox(height: 650, child: const ProductsPanel()),
          ],
        ),
      ),
    );
  }
}
