# 🎬 TMDB Movies

A Flutter application for browsing popular movies using The Movie Database (TMDb) API.

---

## 📱 Features

- Browse popular movies with infinite scroll pagination
- View detailed movie information (overview, genres, rating, runtime)
- Hero animations between list and detail screen
- Add/remove movies from favorites
- Favorites persist across app restarts (Hive local storage)
- Swipe to delete favorites
- Loading shimmer effects
- Error states with retry mechanism
- Pull to refresh

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/tmdb_movies.git
cd tmdb_movies
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root of the project:
```
TMDB_API_KEY=your_tmdb_api_key_here
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p
```

4. Run the app:
```bash
flutter run
```

---

## 📦 Packages Used

| Package | Version | Purpose |
|---|---|---|
| flutter_riverpod | ^2.5.1 | State management |
| riverpod_annotation | ^2.3.5 | Riverpod code generation |
| dio | ^5.4.3 | HTTP client |
| go_router | ^13.2.0 | Navigation |
| cached_network_image | ^3.3.1 | Image caching |
| hive_flutter | ^1.1.0 | Local storage |
| flutter_dotenv | ^5.1.0 | Environment variables |
| fpdart | ^1.1.0 | Functional error handling (Either) |
| shimmer | ^3.0.0 | Loading shimmer effect |

---

## 🏗️ Architecture

The project follows **Clean Architecture** with a **Feature-first** folder structure.
```
lib/
├── core/               # Shared across features
│   ├── constants/      # API and app constants
│   ├── errors/         # Exceptions and failures
│   ├── network/        # Dio client
│   ├── router/         # Go router configuration
│   ├── theme/          # App theme and colors
│   └── utils/          # Utilities (date formatter)
│
├── features/
│   ├── movies/
│   │   ├── data/       # Models, datasources, repository impl
│   │   ├── domain/     # Entities, repository interface, use cases
│   │   └── presentation/ # Providers, screens, widgets
│   │
│   └── favorites/
│       ├── data/       # Local datasource, repository impl
│       ├── domain/     # Repository interface, use cases
│       └── presentation/ # Providers, screens, widgets
│
└── shared/             # Reusable widgets
```

Each feature is divided into three layers:

- **Data** — Knows about JSON, API, Hive. Contains models with `fromJson`, datasources and repository implementations.
- **Domain** — Pure Dart. Contains entities, repository interfaces (abstract classes) and use cases. No dependencies on external packages.
- **Presentation** — UI layer. Contains Riverpod providers, screens and widgets.

---

## 🧠 State Management — Why Riverpod?

**Riverpod** was chosen over Provider and BLoC for the following reasons:

- **Compile-time safety** — providers are verified at compile time, no runtime ProviderNotFoundException
- **No BuildContext dependency** — providers can be accessed outside the widget tree
- **FutureProvider.family** — elegant solution for parameterized async data (movie detail by ID)
- **StateNotifier** — clean separation between state and business logic
- **Provider.family** — efficient per-movie favorite status without rebuilding entire list
- **ref.invalidate()** — simple retry mechanism for failed requests

---

## 🔐 Environment Variables

The API key is stored in a `.env` file and never hardcoded in the source code.
The `.env` file is added to `.gitignore` to prevent accidental exposure.
```
TMDB_API_KEY=your_key_here
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p
```

---

## 🎨 Screens

| Screen | Description |
|---|---|
| Movies List | Paginated list of popular movies with like button |
| Movie Detail | Full movie info with Hero animation, genres, runtime |
| Favorites | Locally saved movies with swipe-to-delete |