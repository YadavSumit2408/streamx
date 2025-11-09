import 'package:hive/hive.dart';
import '../models/movie_model.dart';

abstract class FavoritesLocalDataSource {
  Future<void> addFavorite(MovieModel movie);
  Future<void> removeFavorite(int movieId);
  Future<List<MovieModel>> getFavorites();
  Future<bool> isFavorite(int movieId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final Box favoritesBox;

  FavoritesLocalDataSourceImpl({required this.favoritesBox});

  @override
  Future<void> addFavorite(MovieModel movie) async {
    await favoritesBox.put(movie.id, movie.toJson());
  }

  @override
  Future<void> removeFavorite(int movieId) async {
    await favoritesBox.delete(movieId);
  }

  @override
  Future<List<MovieModel>> getFavorites() async {
    final movies = favoritesBox.values.toList();
    return movies.map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    return favoritesBox.containsKey(movieId);
  }
}
