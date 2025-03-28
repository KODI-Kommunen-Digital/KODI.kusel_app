import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      body: Stack(
        children: [
          Positioned.fill(
            child: _pages[selectedIndex],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: DotNavigationBar(
              backgroundColor: const Color(0xFF18204F),
              selectedItemColor: const Color(0xFF88AF33),
              unselectedItemColor: const Color(0xFFFFFFFF),
              currentIndex: selectedIndex,
              enableFloatingNavBar: true,
              paddingR: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              marginR: const EdgeInsets.all(0),
              onTap: ref.read(dashboardScreenProvider.notifier).onItemTapped,
              dotIndicatorColor: const Color(0xFF88AF33),
              itemPadding:
                  const EdgeInsets.only(top: 8, bottom: 0, left: 16, right: 16),
              items: [
                DotNavigationBarItem(
                  icon: const Icon(Icons.home_filled),
                  selectedColor: const Color(0xFF88AF33),
                ),
                DotNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SvgPicture.asset(
                      height: 13.h,
                      width: 13.w,
                      imagePath['discover_icon'] ?? "",
                      color: selectedIndex == 1
                          ? const Color(0xFF88AF33)
                          : const Color(0xFFFFFFFF),
                    ),
                  ),
                  selectedColor: const Color(0xFF88AF33),
                ),
                DotNavigationBarItem(
                  icon: const Icon(Icons.search),
                  selectedColor: const Color(0xFF88AF33),
                ),
                DotNavigationBarItem(
                  icon: SvgPicture.asset(
                    height: 15.h,
                    width: 13.w,
                    imagePath['location_icon'] ?? "",
                    color: selectedIndex == 3
                        ? const Color(0xFF88AF33)
                        : const Color(0xFFFFFFFF),
                  ),
                  selectedColor: const Color(0xFF88AF33),
                ),
                DotNavigationBarItem(
                  icon: const Icon(Icons.menu),
                  selectedColor: const Color(0xFF88AF33),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
