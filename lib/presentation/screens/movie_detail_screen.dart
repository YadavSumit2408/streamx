import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/constants.dart';
import '../../data/models/movie_model.dart';
import '../providers/bookmark_provider.dart';


class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  // ✅ Named constructor for deep-link or offline open
  factory MovieDetailPage.fromId(int id) {
    // You can later replace this with actual local/Hive fetch
    return MovieDetailPage(
      movie: MovieModel(
        id: id,
        title: "Unknown Movie",
        overview: "This movie was opened via deep link or offline mode.",
        posterPath: null,
        rating: 0.0,
        releaseDate: "",
      ),
    );
  }

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isFavorite = false;
  bool _loadingFavStatus = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final favProvider = context.read<FavoritesProvider>();
    final status = await favProvider.isFavorite(widget.movie.id);
    if (mounted) {
      setState(() {
        isFavorite = status;
        _loadingFavStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    final posterUrl = movie.posterPath != null
        ? "${ApiConstants.imageBaseUrl}${movie.posterPath}"
        : "https://placehold.co/400x600/png?text=No+Image";

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          movie.title ?? "",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              final deepLink = "streamx://movie/${widget.movie.id}";
              Share.share(
                "🎬 Check out this movie on StreamX!\n\n${movie.title}\n\n$deepLink",
                subject: "Watch ${movie.title} on StreamX",
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 🎞 Background Poster
          CachedNetworkImage(
            imageUrl: posterUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/placeholder.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // 🎬 Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),

          // 🧱 Content Layer
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🎞 Poster
                Hero(
                  tag: "poster_${movie.id}",
                  child: ClipRRect(
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
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/placeholder..jpg',
                        width: 220,
                        height: 330,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // 🎬 Title
                Text(
                  movie.title ?? "Untitled",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),

                // ⭐ Rating + 📅 Date
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
                      movie.releaseDate?.isNotEmpty == true
                          ? movie.releaseDate!
                          : "Unknown",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // 📝 Overview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    movie.overview ??
                        "No description available for this movie.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ❤️ Favorite Button
                _loadingFavStatus
                    ? const CircularProgressIndicator(color: Colors.redAccent)
                    : ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<FavoritesProvider>()
                              .toggleFavorite(movie);
                          setState(() => isFavorite = !isFavorite);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.grey[900],
                            content: Text(
                              isFavorite
                                  ? "Added to Favorites ❤️"
                                  : "Removed from Favorites 💔",
                              style: const TextStyle(color: Colors.white),
                            ),
                            duration: const Duration(seconds: 1),
                          ));
                        },
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        label: Text(
                          isFavorite ? "Saved" : "Add to Favorites",
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFavorite
                              ? Colors.redAccent
                              : Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
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
