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
    await trendingBox.put('trending', movies.map((m) => m.toJson()).toList());
  }

  @override
  Future<void> cacheNowPlayingMovies(List<MovieModel> movies) async {
    await nowPlayingBox.put('now_playing', movies.map((m) => m.toJson()).toList());
  }

  @override
  Future<List<MovieModel>> getCachedTrendingMovies() async {
    final data = trendingBox.get('trending');
    if (data != null) {
      return (data as List).map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  @override
  Future<List<MovieModel>> getCachedNowPlayingMovies() async {
    final data = nowPlayingBox.get('now_playing');
    if (data != null) {
      return (data as List).map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }
}
