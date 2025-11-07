import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';


import '../../core/utils/constants.dart';
import '../models/movie_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) {
    dio.options.headers = {
      "accept": "application/json",
      "Authorization": "Bearer ${ApiConstants.v4Token}",
    };
    return _ApiService(dio, baseUrl: baseUrl ?? ApiConstants.baseUrl);
  }

  @GET(ApiConstants.trendingMovies)
  Future<MovieResponse> getTrendingMovies();

  @GET(ApiConstants.nowPlayingMovies)
  Future<MovieResponse> getNowPlayingMovies();

  @GET(ApiConstants.searchMovies)
  Future<MovieResponse> searchMovies(@Query("query") String query);

  @GET("${ApiConstants.movieDetails}/{movieId}")
  Future<MovieModel> getMovieDetails(@Path("movieId") int movieId);
}
