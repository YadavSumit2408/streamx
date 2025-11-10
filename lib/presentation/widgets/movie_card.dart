import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:streamx/data/models/movie_model.dart';
import '../../core/utils/constants.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final poster = ApiConstants.posterOrPlaceholder(movie.posterPath);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(movie: movie),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1E1E1E),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ApiConstants.isLocalAsset(poster)
              ? Image.asset(poster, fit: BoxFit.cover)
              : CachedNetworkImage(
                  imageUrl: poster,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[800]),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/placeholder.jpg',
                          fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }
}
