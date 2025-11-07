

import '../../data/models/movie_model.dart';
import '../repositories/movie_repository.dart';

class GetNowPlayingMoviesUseCase {
  final MovieRepository repository;

  GetNowPlayingMoviesUseCase(this.repository);

  Future<List<MovieModel>> call() async {
    return await repository.getNowPlayingMovies();
  }
}
