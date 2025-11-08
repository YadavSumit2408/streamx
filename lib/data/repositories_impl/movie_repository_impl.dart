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
      print("🌐 Online – fetching trending from API");
      final remoteMovies = await remoteDataSource.getTrendingMovies();
      await localDataSource.cacheTrendingMovies(remoteMovies);
      return remoteMovies;
    } else {
      print("⚠️ Offline – loading trending from cache");
      return await localDataSource.getCachedTrendingMovies();
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final connectionResult = await connectivity.checkConnectivity();

    if (connectionResult != ConnectivityResult.none) {
      print("🌐 Online – fetching now playing from API");
      final remoteMovies = await remoteDataSource.getNowPlayingMovies();
      await localDataSource.cacheNowPlayingMovies(remoteMovies);
      return remoteMovies;
    } else {
      print("⚠️ Offline – loading now playing from cache");
      return await localDataSource.getCachedNowPlayingMovies();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final connectionResult = await connectivity.checkConnectivity();

    if (connectionResult != ConnectivityResult.none) {
      return await remoteDataSource.searchMovies(query);
    } else {
      // Optional offline search
      final cached = await localDataSource.getCachedTrendingMovies();
      return cached
          .where((movie) =>
              movie.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }
}
