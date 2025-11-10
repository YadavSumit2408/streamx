import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/utils/constants.dart';
import '../../data/models/movie_model.dart';

import '../screens/movie_detail_screen.dart';

class MovieBannerWidget extends StatefulWidget {
  final List<MovieModel> movies;

  const MovieBannerWidget({Key? key, required this.movies}) : super(key: key);

  @override
  State<MovieBannerWidget> createState() => _MovieBannerWidgetState();
}

class _MovieBannerWidgetState extends State<MovieBannerWidget> {
  late final PageController _pageController;
  double _currentPage = 1.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.55, initialPage: 1);

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.movies;
    if (movies.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 360, // ⬆️ slightly taller for better layout
      child: PageView.builder(
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final posterUrl = movie.posterPath != null
              ? "${ApiConstants.imageBaseUrl}${movie.posterPath}"
              : null;

          final scale = (1 - (_currentPage - index).abs() * 0.2).clamp(0.8, 1.0);
          final opacity = (1 - (_currentPage - index).abs() * 0.6).clamp(0.0, 1.0);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailPage(movie: movie),
                ),
              );
            },
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Poster
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: posterUrl != null
                          ? CachedNetworkImage(
                              imageUrl: posterUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 350,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[850],
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/placeholder.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 350,
                              ),
                            )
                          : Image.asset(
                              'assets/images/placeholder.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 350,
                            ),
                    ),

                    // Gradient overlay
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Title
                    Positioned(
                      bottom: 30, // ⬆️ creates pseudo-space above the edge
                      left: 20,
                      right: 20,
                      child: Container(
                        constraints: const BoxConstraints(
                          maxHeight: 60, // ⬆️ prevents text overflow
                        ),
                        child: Text(
                          movie.title ?? "",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
