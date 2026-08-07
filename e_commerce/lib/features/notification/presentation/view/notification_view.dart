import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/notification/presentation/view/widgets/notification_view_body.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});
  static const routeName = 'notification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(child: NotificationViewBody()),
    );
  }
}
