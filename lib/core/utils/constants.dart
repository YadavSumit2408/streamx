class ApiConstants {
  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String v4Token =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYjZkZjZkMjM0NjYzNTI4NWE5ZmJlMDc2MGEyMTZlMSIsIm5iZiI6MTc2MjU0NTc2Ny4zMzQsInN1YiI6IjY5MGU1MDY3YjA2MDEzNjAyZmRkMTQ4YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Wqh9NZDzJKUMe5HUrXAUTQJSyG8gw1p2BgJcRR49-xw";
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";
  static const String trendingMovies = "/trending/movie/day";
  static const String nowPlayingMovies = "/movie/now_playing";
  static const String searchMovies = "/search/movie";
  static const String movieDetails = "/movie";
  static String posterOrPlaceholder(String? posterPath) {
    if (posterPath == null) return 'assets/images/placeholder.jpg';
    final trimmed = posterPath.trim();
    if (trimmed.isEmpty) return 'assets/images/placeholder.jpg';
    if (trimmed == 'null') return 'assets/images/placeholder.jpg';
    if (trimmed.startsWith('http')) return trimmed;
    return "$imageBaseUrl$trimmed";
  }

  /// Helper to check if returned value is an asset (local) or network
  static bool isLocalAsset(String urlOrAsset) => urlOrAsset.startsWith('assets/');
}
