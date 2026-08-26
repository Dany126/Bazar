import 'package:e_commerce/dashboard/presentation/theme/dashboard_colors.dart';
import 'package:e_commerce/dashboard/presentation/widgets/common/image_dropzone.dart';
import 'package:e_commerce/dashboard/presentation/widgets/common/light_form_field.dart';
import 'package:e_commerce/dashboard/presentation/widgets/common/primary_pill_button.dart';
import 'package:flutter/material.dart';


/// Add/Edit Product modal — call [show] to present it over the current
/// screen. Presentational only; wire up controllers/submission separately.
class AddEditProductDialog extends StatelessWidget {
  const AddEditProductDialog({super.key, this.isEditing = false});

  final bool isEditing;

  static Future<void> show(BuildContext context, {bool isEditing = false}) {
    return showDialog(
      context: context,
      builder: (_) => AddEditProductDialog(isEditing: isEditing),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Product' : 'Add New Product',
                    style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18, color: DashboardColors.textSecondaryLight),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
              const Divider(height: 24, color: DashboardColors.dividerLight),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Product Image', style: TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
                        SizedBox(height: 6),
                        ImageDropzone(label: 'Upload Image', sublabel: 'PNG, JPG up to 5MB', height: 190),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: const [
                        LightFormField(label: 'Product Name', hint: 'e.g. Premium Leather Jacket'),
                        SizedBox(height: 14),
                        LightFormField(label: 'Description', hint: 'Describe material, fit, and materials...', maxLines: 3),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: LightFormField(label: 'Category', hint: 'Select category')),
                            SizedBox(width: 14),
                            Expanded(child: LightFormField(label: 'Price', hint: '0.00', prefixText: '\$ ')),
                          ],
                        ),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: LightFormField(label: 'Stock Quantity', hint: '0')),
                            SizedBox(width: 14),
                            Expanded(child: LightFormField(label: 'SKU', hint: 'e.g. LTH-JKT-001')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Cancel', style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12.5)),
                  ),
                  const SizedBox(width: 12),
                  PrimaryPillButton(label: isEditing ? 'Save Changes' : 'Save Product', onPressed: () => Navigator.of(context).maybePop()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
