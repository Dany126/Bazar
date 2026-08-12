import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';



// ---------------------------------------------------------
// Timeline Tile
// ---------------------------------------------------------

class TimelineTile extends StatelessWidget {
  final String label;
  final String dateLabel;
  final bool completed;
  final bool isFirst;
  final bool isLast;

  const TimelineTile({
    super.key,
    required this.label,
    required this.dateLabel,
    required this.completed,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = completed ? AppColors.kPrimaryColor : const Color(0xFFE0DDF7);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line + icon
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 12,
                  color: isFirst ? Colors.transparent : color.withOpacity(0.4),
                ),

                Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: completed
                      ? Container(
                          width: 12,
                          height: 12,

                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 8,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),

                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : color.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppStyles.textStylesRegular16(
                        context,
                      ).copyWith(color: completed ? Colors.black : Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    dateLabel,
                    style: AppStyles.textStylesRegular16(
                      context,
                    ).copyWith(color: completed ? Colors.black : Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
