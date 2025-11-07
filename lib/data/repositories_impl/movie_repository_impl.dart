import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/repositories/movie_repository.dart';
import '../models/movie_model.dart';
import '../sources/movie_local_data_source.dart';
import '../sources/movie_remote_data_source.dart';


class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final Connectivity connectivity;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    final connectionResult = await connectivity.checkConnectivity();

    if (connectionResult != ConnectivityResult.none) {
      // Online
      final remoteMovies = await remoteDataSource.getTrendingMovies();
      await localDataSource.cacheTrendingMovies(remoteMovies);
      return remoteMovies;
    } else {
      // Offline
      return await localDataSource.getCachedTrendingMovies();
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final connectionResult = await connectivity.checkConnectivity();

    if (connectionResult != ConnectivityResult.none) {
      final remoteMovies = await remoteDataSource.getNowPlayingMovies();
      await localDataSource.cacheNowPlayingMovies(remoteMovies);
      return remoteMovies;
    } else {
      return await localDataSource.getCachedNowPlayingMovies();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final connectionResult = await connectivity.checkConnectivity();

    if (connectionResult != ConnectivityResult.none) {
      return await remoteDataSource.searchMovies(query);
    } else {
      // Optional: could filter cached movies for offline search
      final cached = await localDataSource.getCachedTrendingMovies();
      return cached
          .where((movie) =>
              movie.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }
}
