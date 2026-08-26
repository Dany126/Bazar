import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/section_card.dart';
import '../widgets/dashboard_shell.dart';
import 'seller_nav.dart';
import 'widgets/customer_info_card.dart';
import 'widgets/order_item_row.dart';
import 'widgets/order_status_stepper.dart';
import 'widgets/payment_summary_card.dart';

/// Seller: Order Detail — status stepper, items, customer/shipping info,
/// and payment/earnings breakdown.
class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Seller Admin',
      navItems: buildSellerNavItems(SellerSection.orders),
      sidebarCtaLabel: 'Add New Product',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      sidebarLight: true,
      topBarLight: true,
      bodyBackground: DashboardColors.contentBgDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('← Back to Orders', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order $orderId', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    const Text('Placed on October 24, 2027 at 10:22 AM', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
                  ],
                ),
                PrimaryPillButton(label: 'Print Invoice', icon: Icons.print_outlined, outlined: true, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionCard(
                          background: DashboardColors.cardBgDarkAlt,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Order Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                              const SizedBox(height: 20),
                              const OrderStatusStepper(steps: ['Pending', 'Processing', 'Shipped', 'Delivered'], currentIndex: 1),
                              const SizedBox(height: 20),
                              const Text('Add Tracking Number', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(color: DashboardColors.cardBgDark, borderRadius: BorderRadius.circular(12)),
                                child: const Text('e.g. 1Z999AA10123456784', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SectionCard(
                          background: DashboardColors.cardBgDarkAlt,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Order Items (2)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                              OrderItemRow(name: 'Vintage Leather Biker Jacket', variant: 'Black · Size M · SKU LTH-002', qty: 1, price: '\$285.00'),
                              Divider(color: DashboardColors.divider, height: 20),
                              OrderItemRow(name: 'Classic Canvas High-Tops', variant: 'White · Size 9 · SKU CNV-014', qty: 1, price: '\$145.00'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomerInfoCard(name: 'Jane Doe', email: 'jane.doe@example.com', phone: '+1 (555) 123-4567'),
                        const SizedBox(height: 20),
                        const AddressCard(title: 'Shipping Address', editable: true, lines: [
                          'Jane Doe',
                          '742 Evergreen Terrace',
                          'Suite 4B',
                          'Denver, CO 80203',
                          'United States',
                        ]),
                        const SizedBox(height: 20),
                        const AddressCard(title: 'Billing Address', lines: ['Same as shipping address']),
                        const SizedBox(height: 20),
                        PaymentSummaryCard(
                          customerLines: const [
                            PaymentSummaryLine('Subtotal', '\$430.00'),
                            PaymentSummaryLine('Shipping (Standard)', '\$8.40'),
                            PaymentSummaryLine('Tax', '\$14.00'),
                          ],
                          totalPaidByCustomer: '\$152.40',
                          platformLines: const [
                            PaymentSummaryLine('Marketplace Commission (8.5%)', '-\$36.55', negative: true),
                            PaymentSummaryLine('Transaction Fee', '-\$3.30', negative: true),
                            PaymentSummaryLine('Shipping Cost (Actual)', '-\$4.55', negative: true),
                          ],
                          netEarning: '\$107.80',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
