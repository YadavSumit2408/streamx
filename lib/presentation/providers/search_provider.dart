import 'dart:async';
import 'package:flutter/material.dart';
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
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (query.isEmpty) {
        _results = [];
        notifyListeners();
        return;
      }

      _isLoading = true;
      notifyListeners();

      try {
        final movies = await repository.searchMovies(query);
        _results = movies;
      } catch (_) {
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
