import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:periodtracker/feature/home/home.dart';
import 'package:periodtracker/feature/home/home_view.dart';
import 'package:periodtracker/feature/more/more.dart';
import 'package:periodtracker/feature/report/report.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Widget> _pages = [const HomeView(), const Report(), const More()];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController, //pages[currentPage],
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 50),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: 100.0, // Reduced to prevent overflow
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  currentIndex: currentPage,
                  onTap: (value) {
                    setState(() {
                      currentPage = value;
                      _pageController.animateToPage(
                        value,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });
                  },
                  selectedItemColor: Color(0xFFE91E63),
                  unselectedItemColor: isDark ? Color(0xFFFFFFFF).withValues(alpha: 0.5) : Color(0x00000000).withValues(alpha: 0.5),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notes),
                      label: 'Report',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'More',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
