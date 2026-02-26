import 'package:flutter/material.dart';
import 'package:tmdb_movies/core/theme/app_colors.dart';

class PaginationLoader extends StatelessWidget {
  const PaginationLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.secondary,
        ),
      ),
    );
  }
}