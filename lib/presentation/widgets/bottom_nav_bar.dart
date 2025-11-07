import 'dart:ui';
import 'package:flutter/material.dart';

import '../screens/bookmarks_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // ✅ allows body content to extend behind nav bar
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _pages[_currentIndex],
          ),

          // 🌫 Floating Glass Nav Bar — does NOT push content up
          Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _currentIndex,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    selectedItemColor: Colors.redAccent,
                    unselectedItemColor: Colors.white.withOpacity(0.6),
                    onTap: (index) => setState(() => _currentIndex = index),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_rounded, size: 26),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.explore_rounded, size: 26),
                        label: "Explore",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite_rounded, size: 26),
                        label: "Favs",
                      ),
                     
                    ],
                    selectedIconTheme: const IconThemeData(
                      color: Colors.redAccent,
                      shadows: [
                        Shadow(
                          color: Colors.redAccent,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
