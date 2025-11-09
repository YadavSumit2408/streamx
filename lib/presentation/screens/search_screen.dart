import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/constants.dart';
import '../../presentation/providers/search_provider.dart';
import '../widgets/movie_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Search Movies"),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: provider.searchMovies,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search for a movie...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (provider.isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.redAccent),
              ),
            )
          else if (provider.results.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "No results found",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: provider.results.length,
                itemBuilder: (context, index) =>
                    MovieCard(movie: provider.results[index]),
              ),
            ),
        ],
      ),
    );
  }
}
