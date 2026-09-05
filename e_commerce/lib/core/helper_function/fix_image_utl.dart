import 'package:e_commerce/constant.dart';

String fixImageUrl(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return '';
  }

  // Already a complete URL.
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
    return imageUrl.replaceFirst(
      RegExp(r'https?://[^/]+'),
      kBaseUrl.replaceFirst('/api', ''),
    );
  }

  final String serverUrl = kBaseUrl.replaceFirst('/api', '');

  if (imageUrl.startsWith('/')) {
    return '$serverUrl$imageUrl';
  }

  return '$serverUrl/$imageUrl';
}
