import 'package:e_commerce/features/notification/presentation/view/widgets/filter_button.dart';
import 'package:e_commerce/features/notification/presentation/view/widgets/notification_view_body.dart';
import 'package:flutter/material.dart';

class NotificationFilterBar extends StatelessWidget {
  final NotificationFilter selectedFilter;
  final void Function(NotificationFilter filter) onFilterSelected;

  const NotificationFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FilterButton(
              label: 'All',
              isSelected: selectedFilter == NotificationFilter.all,
              onTap: () => onFilterSelected(NotificationFilter.all),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilterButton(
              label: 'Read',
              isSelected: selectedFilter == NotificationFilter.read,
              onTap: () => onFilterSelected(NotificationFilter.read),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilterButton(
              label: 'Unread',
              isSelected: selectedFilter == NotificationFilter.unread,
              onTap: () => onFilterSelected(NotificationFilter.unread),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilterButton(
              label: 'Star',
              icon: Icons.star,
              isSelected: selectedFilter == NotificationFilter.favourite,
              onTap: () => onFilterSelected(NotificationFilter.favourite),
            ),
          ),
        ],
      ),
    );
  }
}
