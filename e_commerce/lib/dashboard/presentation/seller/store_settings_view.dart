import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/image_dropzone.dart';
import '../widgets/common/light_form_field.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/section_card.dart';
import '../widgets/dashboard_shell.dart';
import 'seller_nav.dart';

/// Seller: Store Settings — store banner/logo upload and profile details.
class StoreSettingsView extends StatelessWidget {
  const StoreSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Seller Admin',
      navItems: buildSellerNavItems(SellerSection.settings),
      sidebarCtaLabel: 'Add New Product',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      sidebarLight: true,
      topBarLight: true,
      bodyBackground: DashboardColors.contentBgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Store Settings', style: TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text("Manage your store's public profile and system preferences.",
                style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12.5)),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        SectionCard(
                          background: DashboardColors.cardBgLight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Store Banner', style: TextStyle(color: DashboardColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 13.5)),
                              SizedBox(height: 4),
                              Text('Recommended size: 1600x400px', style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11)),
                              SizedBox(height: 12),
                              ImageDropzone(label: 'Upload Banner', height: 130, icon: Icons.image_outlined),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SectionCard(
                          background: DashboardColors.cardBgLight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Store Logo', style: TextStyle(color: DashboardColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 13.5)),
                              SizedBox(height: 12),
                              ImageDropzone(label: 'Upload Logo', sublabel: 'Square format, min 400x400px', height: 150, icon: Icons.storefront_outlined),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: SectionCard(
                      background: DashboardColors.cardBgLight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Profile Details', style: TextStyle(color: DashboardColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(height: 16),
                          const LightFormField(label: 'Store Name', initialValue: 'Urban Sole'),
                          const SizedBox(height: 14),
                          const LightFormField(
                            label: 'Store Bio',
                            initialValue: 'Handcrafted footwear inspired by street style and everyday comfort.',
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),
                          const Text('Contact & Location', style: TextStyle(color: DashboardColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Expanded(child: LightFormField(label: 'Support Email', initialValue: 'support@urbansole.com')),
                              SizedBox(width: 14),
                              Expanded(child: LightFormField(label: 'Phone Number', initialValue: '+1 (555) 987-6543')),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const LightFormField(label: 'Business Address', initialValue: '915 Rockaway St, Suite 300'),
                          const SizedBox(height: 20),
                          const Text('Policies', style: TextStyle(color: DashboardColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(height: 12),
                          const LightFormField(
                            label: 'Return Policy',
                            initialValue: 'Detail your return, refund, and exchange timeframe...',
                            maxLines: 4,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const _CancelText(),
                              const SizedBox(width: 12),
                              PrimaryPillButton(label: 'Save Changes', icon: Icons.save_outlined, onPressed: () {}),
                            ],
                          ),
                        ],
                      ),
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

class _CancelText extends StatelessWidget {
  const _CancelText();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text('Cancel', style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12.5)),
    );
  }
}
