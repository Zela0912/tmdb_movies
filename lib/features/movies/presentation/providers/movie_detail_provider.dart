import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:tmdb_movies/features/movies/domain/usecases/get_movie_detail_usecase.dart';
import 'package:tmdb_movies/features/movies/presentation/providers/movies_provider.dart';

final getMovieDetailUseCaseProvider = Provider<GetMovieDetailUseCase>((ref) {
  return GetMovieDetailUseCase(
    repository: ref.watch(movieRepositoryProvider),
  );
});

final movieDetailProvider = FutureProvider.family<MovieDetail, int>((ref, id) async {
  final useCase = ref.watch(getMovieDetailUseCaseProvider);
  final result = await useCase(id);

  return result.fold(
    (failure) => throw failure.message,
    (movie) => movie,
  );
});