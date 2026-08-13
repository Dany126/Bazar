import 'package:e_commerce/core/services/get_it_services.dart';

import 'package:e_commerce/features/search/presentation/cubit/search_cubit.dart';
import 'package:e_commerce/features/search/presentation/views/widgets/search_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (_) => getIt<SearchCubit>(),
      child: const SearchViewBody(),
    );
  }
}
