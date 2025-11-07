import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streamx/presentation/providers/movie_provider.dart';
import 'package:streamx/presentation/screens/home_screen.dart';
import 'package:streamx/presentation/widgets/bottom_nav_bar.dart';

import 'data/repositories_impl/movie_repository_impl.dart';
import 'data/services/api_service.dart';
import 'data/sources/movie_local_data_source.dart';
import 'data/sources/movie_remote_data_source.dart';
import 'domain/use_cases/get_now_playing_movies_usecase.dart';
import 'domain/use_cases/get_trending_movies_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final trendingBox = await Hive.openBox('trendingBox');
  final nowPlayingBox = await Hive.openBox('nowPlayingBox');

  final dio = Dio();
  dio.httpClientAdapter.close(force: true);
  final apiService = ApiService(dio);
  final remote = MovieRemoteDataSourceImpl(apiService);
  final local = MovieLocalDataSourceImpl(
    trendingBox: trendingBox,
    nowPlayingBox: nowPlayingBox,
  );
  final repo = MovieRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
    connectivity: Connectivity(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieProvider(
            getTrendingMoviesUseCase: GetTrendingMoviesUseCase(repo),
            getNowPlayingMoviesUseCase: GetNowPlayingMoviesUseCase(repo),
          ),
        ),
      ],
      child: const StreamixApp(),
    ),
  );
}

class StreamixApp extends StatelessWidget {
  const StreamixApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.redAccent,
      ),
      home: const BottomNavBar(),
    );
  }
}
