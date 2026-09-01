import 'package:flutter/foundation.dart';

String fixImageUrl(String url) {
  if (kIsWeb) {
    // Web: convert 10.0.2.2 to localhost
    return url.replaceFirst('http://10.0.2.2:5000', 'http://localhost:5000');
  } else {
    // Native: convert localhost to 10.0.2.2
    return url.replaceFirst('http://localhost:5000', 'http://10.0.2.2:5000');
  }
}
