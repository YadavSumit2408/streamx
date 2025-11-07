

import 'dart:developer';

import '../models/movie_model.dart';
import '../services/api_service.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getTrendingMovies();
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiService apiService;

  MovieRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      print("🔹 Fetching trending movies...");
      final response = await apiService.getTrendingMovies();
      print("✅ Trending fetched: ${response.results.length}");
      return response.results;
    } catch (e, s) {
      log("❌ Trending movies fetch failed: $e", stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      print("🔹 Fetching now playing movies...");
      final response = await apiService.getNowPlayingMovies();
      print("✅ Now Playing fetched: ${response.results.length}");
      return response.results;
    } catch (e, s) {
      log("❌ Now Playing fetch failed: $e", stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      print("🔹 Searching movies...");
      final response = await apiService.searchMovies(query);
      print("✅ Search fetched: ${response.results.length}");
      return response.results;
    } catch (e, s) {
      log("❌ Search fetch failed: $e", stackTrace: s);
      rethrow;
    }
  }
}