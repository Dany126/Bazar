import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

class ProposedProductCard extends StatelessWidget {
  const ProposedProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl,
  });

  final String name;
  final String category;
  final String price;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Container(
              decoration: BoxDecoration(
                color: DashboardColors.cardBgDarkAlt,
                image: imageUrl != null
                    ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                    : null,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(price, style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600)),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
                  Text(category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 10.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Trailing tile shown when there are more proposed products than fit
/// on screen (e.g. "+7 more products").
class ProposedProductsMoreTile extends StatelessWidget {
  const ProposedProductsMoreTile({super.key, required this.remainingCount});

  final int remainingCount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 0.9,
        child: Container(
          color: DashboardColors.cardBgDarkAlt,
          alignment: Alignment.center,
          child: Text(
            '+$remainingCount\nmore products',
            textAlign: TextAlign.center,
            style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
