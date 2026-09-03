import 'package:flutter/foundation.dart';

/// Converts an image URL returned by the backend into a URL
/// that can actually be reached from the current Flutter platform.
///
/// Backend normally returns:
///   http://localhost:5000/public/filename.jpg
///
/// Flutter Web:
///   localhost:5000
///
/// Android emulator:
///   10.0.2.2:5000
///
/// Physical device:
///   You should eventually replace localhost with your
///   computer's LAN IP or production API host.
String fixImageUrl(String? url) {
  if (url == null) {
    return '';
  }

  String imageUrl = url.trim();

  if (imageUrl.isEmpty) {
    return '';
  }

  // Remove accidental quotes that can sometimes exist
  // in stored JSON/string values.
  imageUrl = imageUrl.replaceAll('"', '').trim();

  if (imageUrl.isEmpty) {
    return '';
  }

  // ----------------------------------------------------------
  // RELATIVE URL
  // ----------------------------------------------------------
  //
  // Example:
  // /public/abc.jpg
  //
  // Convert it to the correct backend host.
  //
  if (imageUrl.startsWith('/')) {
    if (kIsWeb) {
      return 'http://localhost:5000$imageUrl';
    }

    return 'http://10.0.2.2:5000$imageUrl';
  }

  // ----------------------------------------------------------
  // WEB
  // ----------------------------------------------------------
  if (kIsWeb) {
    return imageUrl
        .replaceFirst('http://10.0.2.2:5000', 'http://localhost:5000')
        .replaceFirst('http://127.0.0.1:5000', 'http://localhost:5000');
  }

  // ----------------------------------------------------------
  // ANDROID EMULATOR / NATIVE
  // ----------------------------------------------------------
  return imageUrl
      .replaceFirst('http://localhost:5000', 'http://10.0.2.2:5000')
      .replaceFirst('http://127.0.0.1:5000', 'http://10.0.2.2:5000');
}
