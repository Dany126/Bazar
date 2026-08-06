import 'package:e_commerce/features/notification/presentation/view/widgets/notification_view_body.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});
  static const routeName = 'notification';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: NotificationViewBody()));
  }
}
