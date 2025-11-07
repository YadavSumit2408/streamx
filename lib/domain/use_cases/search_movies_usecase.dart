
import '../../data/models/movie_model.dart';
import '../repositories/movie_repository.dart';

class SearchMoviesUseCase {
  final MovieRepository repository;

  SearchMoviesUseCase(this.repository);

  Future<List<MovieModel>> call(String query) async {
    return await repository.searchMovies(query);
  }
}
