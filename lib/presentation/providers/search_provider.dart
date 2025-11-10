import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/movie_model.dart';
import '../../domain/repositories/movie_repository.dart';

class SearchProvider extends ChangeNotifier {
  final MovieRepository repository;
  List<MovieModel> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  List<MovieModel> get results => _results;
  bool get isLoading => _isLoading;

  SearchProvider(this.repository);

  void searchMovies(String query) {
    // Cancel previous
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final q = query.trim();
      if (q.isEmpty) {
        _results = [];
        notifyListeners();
        return;
      }

      _isLoading = true;
      notifyListeners();

      try {
        final movies = await repository.searchMovies(q);

        // Filter out or normalize any broken entries (defensive)
        _results = movies.map((m) {
          // ensure posterPath normalized (optional)
          final safePoster = (m.posterPath == null || m.posterPath == 'null' || m.posterPath!.isEmpty)
              ? null
              : m.posterPath;
          return MovieModel(
            id: m.id,
            title: m.title,
            posterPath: safePoster,
            overview: m.overview,
            rating: m.rating,
            releaseDate: m.releaseDate,
          );
        }).toList();
      } catch (e, st) {
        debugPrint("Search error: $e\n$st");
        // fallback to empty or cached result
        _results = [];
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
