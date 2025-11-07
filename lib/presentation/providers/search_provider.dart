import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../data/models/movie_model.dart';
import '../../domain/use_cases/search_movies_usecase.dart';

class SearchProvider extends ChangeNotifier {
  final SearchMoviesUseCase searchMoviesUseCase;

  SearchProvider(this.searchMoviesUseCase);

  List<MovieModel> searchResults = [];
  bool isLoading = false;
  String? errorMessage;
  Timer? _debounce;

  void search(String query) {
    if (query.isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        isLoading = true;
        notifyListeners();

        final results = await searchMoviesUseCase.call(query);
        searchResults = results;
        isLoading = false;
        notifyListeners();
      } catch (e) {
        isLoading = false;
        errorMessage = e.toString();
        notifyListeners();
      }
    });
  }
}
