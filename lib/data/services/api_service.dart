import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:streamx/core/utils/constants.dart';
import 'package:streamx/data/models/movie_model.dart';


part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(ApiConstants.trendingMovies)
  Future<MovieResponse> getTrendingMovies(
    @Query("api_key") String apiKey,
  );

  @GET(ApiConstants.nowPlayingMovies)
  Future<MovieResponse> getNowPlayingMovies(
    @Query("api_key") String apiKey,
  );

  @GET(ApiConstants.searchMovies)
  Future<MovieResponse> searchMovies(
    @Query("api_key") String apiKey,
    @Query("query") String query,
  );

  @GET("${ApiConstants.movieDetails}/{movieId}")
  Future<MovieModel> getMovieDetails(
    @Path("movieId") int movieId,
    @Query("api_key") String apiKey,
  );
}
