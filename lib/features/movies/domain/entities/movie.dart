class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final double voteAverage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Movie && other.id == id;

  @override
  int get hashCode => id.hashCode;
}