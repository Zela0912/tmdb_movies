import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_movies/features/movies/presentation/screens/movies_list_screen.dart';
import 'package:tmdb_movies/features/movies/presentation/screens/movie_detail_screen.dart';
import 'package:tmdb_movies/features/favorites/presentation/screens/favorites_screen.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String movieDetail = '/movie/:id';
  static const String favorites = '/favorites';

  static String movieDetailPath(int id) => '/movie/$id';

  static final router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MoviesListScreen(),
            ),
          ),
          GoRoute(
            path: favorites,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FavoritesScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: movieDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MovieDetailScreen(movieId: id);
        },
      ),
    ],
  );
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: location == AppRouter.favorites ? 1 : 0,
        onTap: (index) {
          if (index == 0) context.go(AppRouter.home);
          if (index == 1) context.go(AppRouter.favorites);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_outlined),
            activeIcon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
