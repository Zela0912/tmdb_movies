class MovieDetail {
  const MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.genres,
    required this.runtime,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final double voteAverage;
  final List<String> genres;
  final int? runtime;
}
