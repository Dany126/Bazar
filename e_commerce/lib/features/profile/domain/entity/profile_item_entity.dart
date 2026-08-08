import 'package:flutter/material.dart';

class ProfileItemEntity {
  final String title;
  final VoidCallback onTap;

  const ProfileItemEntity({required this.title, required this.onTap});
}
