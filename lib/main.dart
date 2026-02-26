import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tmdb_movies/app.dart';
import 'package:tmdb_movies/core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env
  await dotenv.load(fileName: '.env');

  // Init Hive
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.favoritesBoxName);

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}