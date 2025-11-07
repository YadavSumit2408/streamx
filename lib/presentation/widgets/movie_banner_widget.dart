import 'package:flutter/material.dart';

import '../../core/utils/constants.dart';
import '../../data/models/movie_model.dart';


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
      height: 340,
      child: PageView.builder(
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          
          final scale = (1 - (_currentPage - index).abs() * 0.2).clamp(0.8, 1.0);
          final opacity = (1 - (_currentPage - index).abs() * 0.6).clamp(0.0, 1.0);

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      "${ApiConstants.imageBaseUrl}${movie.posterPath}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 330,
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                              ? child
                              : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  Container(
                    height: 330,
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
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      movie.title ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
