import '../../domain/repositories/favorites_repository.dart';
import '../models/movie_model.dart';
import '../sources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addFavorite(MovieModel movie) => localDataSource.addFavorite(movie);

  @override
  Future<void> removeFavorite(int movieId) => localDataSource.removeFavorite(movieId);

  @override
  Future<List<MovieModel>> getFavorites() => localDataSource.getFavorites();

  @override
  Future<bool> isFavorite(int movieId) => localDataSource.isFavorite(movieId);
}
