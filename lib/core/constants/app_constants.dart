class AppConstants {
  AppConstants._();

  // Pagination
  static const int moviesPerPage = 20;

  // Image sizes - sve veličine iz TMDb dokumentacije
  static const String posterSizeW92 = 'w92';
  static const String posterSizeW154 = 'w154';
  static const String posterSizeW185 = 'w185';
  static const String posterSizeW342 = 'w342';
  static const String posterSizeW500 = 'w500';
  static const String posterSizeW780 = 'w780';
  static const String posterSizeOriginal = 'original';

  // Hive
  static const String favoritesBoxName = 'favorites_box';
  static const String favoritesKey = 'favorites';

  // UI
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 12.0;
  static const double smallPadding = 8.0;

  // Movie card - lista koristi w342, detalji w500
  static const String listPosterSize = posterSizeW342;
  static const String detailPosterSize = posterSizeW500;
  static const String thumbnailPosterSize = posterSizeW185;
}
