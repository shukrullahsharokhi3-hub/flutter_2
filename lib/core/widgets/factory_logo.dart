import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Reusable factory mark used by the splash and login screens.
///
/// The icon is drawn with Flutter widgets so the app does not depend on a
/// separate image asset for its temporary logo.
class FactoryLogo extends StatelessWidget {
  const FactoryLogo({
    super.key,
    required this.size,
    this.backgroundColor = AppColors.navy,
    this.accentColor = AppColors.lightPurple,
    this.accentIconColor = Colors.white,
    this.iconColor = Colors.white,
  });

  final double size;
  final Color backgroundColor;
  final Color accentColor;
  final Color accentIconColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Allow pale palette backgrounds to use a dark, readable mark.
          Icon(Icons.factory_outlined, size: size * 0.52, color: iconColor),
          Positioned(
            right: size * 0.16,
            bottom: size * 0.16,
            child: Container(
              width: size * 0.24,
              height: size * 0.24,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
                border: Border.all(color: backgroundColor, width: 3),
              ),
              child: Icon(
                Icons.check,
                color: accentIconColor,
                size: size * 0.14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
