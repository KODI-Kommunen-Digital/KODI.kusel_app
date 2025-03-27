import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../../common_widgets/highlights_card.dart';
import '../../images_path.dart';
import '../explore/explore_screen.dart';
import '../home/home_screen.dart';
import '../location/location_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import 'dashboard_screen_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final List<Widget> _pages = [
    HomeScreen(),
    ExploreScreen(),
    SearchScreen(),
    LocationScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(dashboardScreenProvider).selectedIndex;

    return Scaffold(
      backgroundColor: Color(0xFFE2EBF7),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: _pages[selectedIndex],
      ),
      bottomNavigationBar: DotNavigationBar(
        backgroundColor: Color(0xFF18204F),
        selectedItemColor: Color(0xFF88AF33),
        unselectedItemColor: Color(0xFFFFFFFF),
        currentIndex: selectedIndex,
        enableFloatingNavBar: true,
        marginR: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        onTap: ref.read(dashboardScreenProvider.notifier).onItemTapped,
        dotIndicatorColor: Color(0xFF88AF33),
        items: [
          DotNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            selectedColor: Color(0xFF88AF33),
          ),
          DotNavigationBarItem(
            icon: SvgPicture.asset(
              imagePath['discover_icon'] ?? "",
              color: selectedIndex == 1 ? Color(0xFF88AF33) : Color(0xFFFFFFFF),
            ),
            selectedColor: Color(0xFF88AF33),
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.search),
            selectedColor: Color(0xFF88AF33),
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.location_on_sharp),
            selectedColor: Color(0xFF88AF33),
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.menu),
            selectedColor: Color(0xFF88AF33),
          ),
        ],
      ),
    );
  }
}
