import 'package:flutter/foundation.dart';

import '../../data/models/movie_model.dart';
import '../../domain/use_cases/get_now_playing_movies_usecase.dart';
import '../../domain/use_cases/get_trending_movies_usecase.dart';


class MovieProvider extends ChangeNotifier {
  final GetTrendingMoviesUseCase getTrendingMoviesUseCase;
  final GetNowPlayingMoviesUseCase getNowPlayingMoviesUseCase;

  MovieProvider({
    required this.getTrendingMoviesUseCase,
    required this.getNowPlayingMoviesUseCase,
  });

  List<MovieModel> trendingMovies = [];
  List<MovieModel> nowPlayingMovies = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchMovies() async {
    try {
      isLoading = true;
      notifyListeners();

      final trending = await getTrendingMoviesUseCase.call();
      final nowPlaying = await getNowPlayingMoviesUseCase.call();

      trendingMovies = trending;
      nowPlayingMovies = nowPlaying;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
