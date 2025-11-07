

import '../../core/utils/constants.dart';
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
    final response = await apiService.getTrendingMovies(ApiConstants.apiKey);
    return response.results;
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await apiService.getNowPlayingMovies(ApiConstants.apiKey);
    return response.results;
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await apiService.searchMovies(ApiConstants.apiKey, query);
    return response.results;
  }
}
