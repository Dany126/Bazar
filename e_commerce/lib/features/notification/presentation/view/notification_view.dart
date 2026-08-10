import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:e_commerce/features/notification/presentation/view/widgets/notification_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  static const routeName = 'notification';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..fetchAllNotifications(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Notification",
            style: AppStyles.textStylesBold22Mono(
              context,
            ).copyWith(color: Colors.black),
          ),
        ),
        body: const SafeArea(child: NotificationViewBody()),
      ),
    );
  }
}
