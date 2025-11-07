import 'package:flutter/material.dart';


import '../../core/utils/constants.dart';
import '../../data/models/movie_model.dart';

class MovieListSection extends StatelessWidget {
  final String title;
  final List<MovieModel> movies;

  const MovieListSection({
    Key? key,
    required this.title,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "${ApiConstants.imageBaseUrl}${movie.posterPath}",
                    fit: BoxFit.cover,
                    width: 120,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
