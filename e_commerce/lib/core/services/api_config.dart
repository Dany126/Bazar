import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    // Flutter Web
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }

    // Android physical phone
    return 'http://192.168.1.2:5000/api';
  }
}
