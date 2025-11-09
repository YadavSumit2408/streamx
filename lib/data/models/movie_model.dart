import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieResponse {
  final int page;
  final List<MovieModel> results;

  MovieResponse({
    required this.page,
    required this.results,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@JsonSerializable()
class MovieModel {
  final int id;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  @JsonKey(name: 'overview')
  final String? overview;

  @JsonKey(name: 'vote_average')
  final double? rating;

  @JsonKey(name: 'release_date')
  final String? releaseDate;

  MovieModel({
    required this.id,
    this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.rating,
    this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}
