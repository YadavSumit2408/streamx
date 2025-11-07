import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../widgets/movie_banner_widget.dart';
import '../widgets/movie_list_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final trending = movieProvider.trendingMovies;
    final nowPlaying = movieProvider.nowPlayingMovies;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MovieBannerWidget(movies: trending.take(5).toList()),

              const SizedBox(height: 16),

              // 🔥 Trending Section
              MovieListSection(
                title: "Trending Now",
                movies: trending,
              ),

              // 🎞️ Now Playing Section
              MovieListSection(
                title: "Now Playing",
                movies: nowPlaying,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
