import '../../data/models/movie_model.dart';

abstract class FavoritesRepository {
  Future<void> addFavorite(MovieModel movie);
  Future<void> removeFavorite(int movieId);
  Future<List<MovieModel>> getFavorites();
  Future<bool> isFavorite(int movieId);
}
