class ApiConstants {
  static const String baseUrl = "https://api.themoviedb.org/3";

  // ⚠️ Paste your own TMDB v4 token here (from the dashboard)
  static const String v4Token =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZjY3YTVkYmJmYjAzYjc3YzA3ODg5ZWZhZDVjMmVkNCIsIm5iZiI6MTc2MjU0NTc2Ny4zMzQsInN1YiI6IjY5MGU1MDY3YjA2MDEzNjAyZmRkMTQ4YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NjinJJQ60HBWiSm7azzOu8mi33THiGlXTv49pUCN6sA";

  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

  static const String trendingMovies = "/trending/movie/day";
  static const String nowPlayingMovies = "/movie/now_playing";
  static const String searchMovies = "/search/movie";
  static const String movieDetails = "/movie";
}
