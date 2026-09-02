import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_user.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_users_cubit.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminWorkspaceView extends StatelessWidget {
  const AdminWorkspaceView({super.key});
  @override Widget build(BuildContext context) => BlocProvider(create: (_) => getIt<AdminUsersCubit>()..load(), child: const _CustomersBody());
}
class _CustomersBody extends StatelessWidget {
  const _CustomersBody();
  @override Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => context.read<AdminUsersCubit>().load(),
    child: SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Workspace', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 24),
      BlocBuilder<AdminUsersCubit, AdminUsersState>(builder: (context,state) {
        if (state is AdminUsersLoading || state is AdminUsersInitial) return const Center(child: Padding(padding: EdgeInsets.all(60), child: CircularProgressIndicator()));
        if (state is AdminUsersFailure) return Center(child: Text(state.message));
        final users=(state as AdminUsersLoaded).users.where((u)=>u.role.toLowerCase()!='admin').toList();
        if(users.isEmpty) return const Padding(padding: EdgeInsets.all(60), child: Center(child: Text('No data')));
        return Card(elevation:0, child: ListView.separated(shrinkWrap:true, physics:const NeverScrollableScrollPhysics(), itemCount:users.length, separatorBuilder:(_,__)=>const Divider(height:1), itemBuilder:(context,i){final u=users[i]; return _UserTile(user:u); }));
      })
    ])));
}
class _UserTile extends StatelessWidget { final AdminUser user; const _UserTile({required this.user}); @override Widget build(BuildContext context){ final initial=user.name.trim().isEmpty?'?':user.name.trim()[0].toUpperCase(); return ListTile(leading:CircleAvatar(backgroundColor:AppColors.kPrimaryColor.withValues(alpha:.1),child:Text(initial,style:const TextStyle(color:AppColors.kPrimaryColor))),title:Text(user.name.isEmpty?'No name':user.name),subtitle:Text(user.email.isEmpty?'No email':user.email),trailing:user.phone==null?null:Text(user.phone!)); } }
