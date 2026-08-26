import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/settings_field.dart';
import 'widgets/settings_section_card.dart';

/// Super Admin: Platform Settings — commission, payout schedule, and
/// payment method configuration.
class PlatformSettingsView extends StatelessWidget {
  const PlatformSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.settings),
      sidebarCtaLabel: 'Add New Seller',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Platform Settings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Configure marketplace-wide rules and preferences.',
                        style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
                  ],
                ),
                PrimaryPillButton(label: 'Save Changes', icon: Icons.save_outlined, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: SettingsSectionCard(
                      title: 'General Marketplace Info',
                      icon: Icons.storefront_outlined,
                      child: Column(
                        children: const [
                          Row(
                            children: [
                              Expanded(child: SettingsField(label: 'Marketplace Name', initialValue: 'Clot Marketplace')),
                              SizedBox(width: 16),
                              Expanded(child: SettingsField(label: 'Support Email', initialValue: 'support@clotmarketplace.com')),
                            ],
                          ),
                          SizedBox(height: 14),
                          SettingsField(
                            label: 'Platform Description',
                            initialValue: 'A curated multi-vendor marketplace for independent apparel and home goods sellers.',
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: SettingsSectionCard(
                      title: 'Commission Rate',
                      icon: Icons.percent_rounded,
                      child: Column(
                        children: const [
                          SettingsField(label: 'Default Commission (%)', initialValue: '8.5'),
                          SizedBox(height: 14),
                          SettingsField(label: 'Featured Placement Fee (%)', initialValue: '2.0'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SettingsSectionCard(
                      title: 'Payout Schedule',
                      icon: Icons.event_repeat_rounded,
                      child: Column(
                        children: [
                          _scheduleOption('Weekly', 'Every Friday', selected: true),
                          const SizedBox(height: 10),
                          _scheduleOption('Bi-weekly', 'Every other Friday', selected: false),
                          const SizedBox(height: 10),
                          _scheduleOption('Monthly', 'First business day', selected: false),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SettingsSectionCard(
                      title: 'Active Payment Methods',
                      icon: Icons.credit_card_rounded,
                      child: Column(
                        children: const [
                          Row(
                            children: [
                              Expanded(child: SettingsToggleRow(icon: Icons.credit_card_rounded, label: 'Credit / Debit Card', sublabel: 'Stripe', value: true)),
                              SizedBox(width: 10),
                              Expanded(child: SettingsToggleRow(icon: Icons.smartphone_rounded, label: 'Mobile Wallets', sublabel: 'Apple / Google Pay', value: true)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: SettingsToggleRow(icon: Icons.account_balance_rounded, label: 'Bank Transfer', sublabel: 'ACH direct debit', value: true)),
                              SizedBox(width: 10),
                              Expanded(child: SettingsToggleRow(icon: Icons.paypal_rounded, label: 'PayPal', sublabel: 'Disabled', value: false)),
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

  Widget _scheduleOption(String label, String sublabel, {required bool selected}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DashboardColors.cardBgDarkAlt,
        borderRadius: BorderRadius.circular(12),
        border: selected ? Border.all(color: DashboardColors.accent) : null,
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
            size: 18,
            color: selected ? DashboardColors.accent : DashboardColors.textSecondaryDark,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
              Text(sublabel, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 10.5)),
            ],
          ),
        ],
      ),
    );
  }
}
