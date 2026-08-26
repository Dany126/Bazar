import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

/// Dashed-border image upload dropzone used in product and store forms.
class ImageDropzone extends StatelessWidget {
  const ImageDropzone({
    super.key,
    this.label = 'Upload Image',
    this.sublabel,
    this.height = 200,
    this.icon = Icons.add_photo_alternate_outlined,
  });

  final String label;
  final String? sublabel;
  final double height;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DottedBorderBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: DashboardColors.accentSoft, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: DashboardColors.accent),
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: DashboardColors.accent, fontSize: 12.5, fontWeight: FontWeight.w600)),
          if (sublabel != null) ...[
            const SizedBox(height: 4),
            Text(sublabel!, style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 10.5)),
          ],
        ],
      ),
    );
  }
}

/// A simple dashed-look border container (approximated with a dotted
/// custom painter) wrapping [child].
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child, this.height});

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Center(child: child),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DashboardColors.textSecondaryLight.withOpacity(0.4)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(14));
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
