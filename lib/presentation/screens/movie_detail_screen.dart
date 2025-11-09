import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../core/utils/constants.dart';
import '../../data/models/movie_model.dart';
import '../providers/bookmark_provider.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
 
bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus(); // ✅ load async data outside build()
  }

  Future<void> _checkFavoriteStatus() async {
    final favProvider = context.read<FavoritesProvider>();
    final favStatus = await favProvider.isFavorite(widget.movie.id);
    setState(() {
      isFavorite = favStatus;
    });
  }
  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final posterUrl = movie.posterPath != null
        ? "${ApiConstants.imageBaseUrl}${movie.posterPath}"
        : "https://via.placeholder.com/400x600.png?text=No+Image";
       


    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background poster with blur overlay
          CachedNetworkImage(
            imageUrl: posterUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/placeholder.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Cinematic blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 10),

                // Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: posterUrl,
                    width: 220,
                    height: 330,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 220,
                      height: 330,
                      color: Colors.grey[850],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  movie.title ?? "Untitled",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // Rating + Release Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      "${movie.rating?.toStringAsFixed(1) ?? 'N/A'} / 10",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.calendar_today,
                        color: Colors.white70, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      movie.releaseDate ?? "Unknown",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Overview
                Text(
                  movie.overview ?? "No description available.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 35),

                // Favorite Button
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<FavoritesProvider>().toggleFavorite(movie);
                    setState(() => isFavorite = !isFavorite);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(isFavorite
                          ? "Added to Favorites ❤️"
                          : "Removed from Favorites 💔"),
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  label: Text(
                    isFavorite ? "Saved" : "Add to Favorites",
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFavorite ? Colors.redAccent : Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
