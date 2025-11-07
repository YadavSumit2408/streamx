

import '../../data/models/movie_model.dart';
import '../repositories/movie_repository.dart';

class GetTrendingMoviesUseCase {
  final MovieRepository repository;

  GetTrendingMoviesUseCase(this.repository);

  Future<List<MovieModel>> call() async {
    return await repository.getTrendingMovies();
  }
}
