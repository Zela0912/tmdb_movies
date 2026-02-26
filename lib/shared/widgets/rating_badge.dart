import 'package:flutter/material.dart';
import 'package:tmdb_movies/core/theme/app_colors.dart';

class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating});

  final double rating;

  Color get _ratingColor {
    if (rating >= 7.0) return AppColors.ratingHigh;
    if (rating >= 5.0) return AppColors.ratingMedium;
    return AppColors.ratingLow;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _ratingColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _ratingColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: _ratingColor, size: 14),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: _ratingColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}