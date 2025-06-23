import 'package:flutter/material.dart';
import 'package:periodtracker/feature/home/home.dart';
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

  final List<Widget> _pages = [
    const Home(),
    const Report(),
    const More()
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController, //pages[currentPage],
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notes),
              label: 'Report'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'More'
          ),
        ],
      ),
    );
  }
}
