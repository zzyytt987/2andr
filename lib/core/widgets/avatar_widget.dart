import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String fallback;
  final double size;
  final bool showOnlineDot;
  final bool isOnline;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    required this.fallback,
    this.size = 48,
    this.showOnlineDot = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primary,
                  Color(0xFF0D5DD9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(size * 0.3),
            ),
            alignment: Alignment.center,
            child: Text(fallback,
                style: TextStyle(fontSize: size * 0.45)),
          ),
          if (showOnlineDot)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  color: isOnline ? AppColors.success : AppColors.mutedForeground,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.card, width: size * 0.05),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
