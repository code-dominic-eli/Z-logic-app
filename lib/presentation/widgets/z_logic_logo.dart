import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ZLogicLogo extends StatelessWidget {
  final double size;

  const ZLogicLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(size * 0.15),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.crop_free, color: AppColors.primary, size: size * 0.6), // Microchip frame
          Icon(Icons.house, color: AppColors.primary, size: size * 0.4), // House
          Positioned(
            bottom: 0,
            right: 0,
            child: Text(
              'Z',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: size * 0.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
