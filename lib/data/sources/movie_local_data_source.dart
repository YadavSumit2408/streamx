import 'package:hive/hive.dart';
import '../models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<void> cacheTrendingMovies(List<MovieModel> movies);
  Future<void> cacheNowPlayingMovies(List<MovieModel> movies);
  Future<List<MovieModel>> getCachedTrendingMovies();
  Future<List<MovieModel>> getCachedNowPlayingMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box trendingBox;
  final Box nowPlayingBox;

  MovieLocalDataSourceImpl({
    required this.trendingBox,
    required this.nowPlayingBox,
  });

  @override
  Future<void> cacheTrendingMovies(List<MovieModel> movies) async {
    try {
      await trendingBox.clear(); // ✅ avoid duplicate data
     await trendingBox.put('trending', movies.map((m) => m.toJson()).toList());

      print("💾 Cached trending movies: ${movies.length}");
    } catch (e) {
      print("⚠️ Error caching trending movies: $e");
    }
  }

  @override
  Future<void> cacheNowPlayingMovies(List<MovieModel> movies) async {
    try {
      await nowPlayingBox.clear();
      await nowPlayingBox.put(
        'now_playing',
        movies.map((m) => m.toJson()).toList(),
      );
      print("💾 Cached now playing movies: ${movies.length}");
    } catch (e) {
      print("⚠️ Error caching now playing movies: $e");
    }
  }

  @override
  Future<List<MovieModel>> getCachedTrendingMovies() async {
    try {
      final data = trendingBox.get('trending');
      if (data == null) return [];
      return (data as List)
          .map((e) =>
              MovieModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      print("⚠️ Error reading trending cache: $e");
      return [];
    }
  }

  @override
  Future<List<MovieModel>> getCachedNowPlayingMovies() async {
    try {
      final data = nowPlayingBox.get('now_playing');
      if (data == null) return [];
      return (data as List)
          .map((e) =>
              MovieModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      print("⚠️ Error reading now playing cache: $e");
      return [];
    }
  }
}
