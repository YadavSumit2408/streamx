import 'package:flutter/foundation.dart';
import '../../data/models/movie_model.dart';
import '../../domain/repositories/favorites_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository repository;

  List<MovieModel> _favorites = [];
  List<MovieModel> get favorites => _favorites;

  FavoritesProvider({required this.repository});

  Future<void> loadFavorites() async {
    _favorites = await repository.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(MovieModel movie) async {
    final exists = await repository.isFavorite(movie.id);
    if (exists) {
      await repository.removeFavorite(movie.id);
      _favorites.removeWhere((m) => m.id == movie.id);
    } else {
      await repository.addFavorite(movie);
      _favorites.add(movie);
    }
    notifyListeners();
  }

  Future<bool> isFavorite(int movieId) async {
    return await repository.isFavorite(movieId);
  }
}
