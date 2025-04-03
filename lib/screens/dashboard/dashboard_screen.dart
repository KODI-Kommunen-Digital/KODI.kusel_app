import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/screens/event/event_screen.dart';

import '../../common_widgets/highlights_card.dart';
import '../../images_path.dart';
import '../../theme_manager/colors.dart';
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
    EventScreen(),
    LocationScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(dashboardScreenProvider).selectedIndex;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              backgroundColor: lightThemeSecondaryColor,
              selectedItemColor: lightThemeSelectedItemColor,
              unselectedItemColor: lightThemeWhiteColor,
              currentIndex: selectedIndex,
              enableFloatingNavBar: true,
              paddingR: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              marginR: const EdgeInsets.all(0),
              onTap: ref.read(dashboardScreenProvider.notifier).onItemTapped,
              dotIndicatorColor: lightThemeSelectedItemColor,
              itemPadding:
                  const EdgeInsets.only(top: 8, bottom: 0, left: 16, right: 16),
              items: [
                DotNavigationBarItem(
                  icon: const Icon(Icons.home_filled),
                  selectedColor: lightThemeSelectedItemColor,
                ),
                DotNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SvgPicture.asset(
                      height: 13.h,
                      width: 13.w,
                      imagePath['discover_icon'] ?? "",
                      color: selectedIndex == 1
                          ? lightThemeSelectedItemColor
                          : lightThemeWhiteColor,
                    ),
                  ),
                  selectedColor: lightThemeSelectedItemColor,
                ),
                DotNavigationBarItem(
                  icon: const Icon(Icons.search),
                  selectedColor: lightThemeSelectedItemColor,
                ),
                DotNavigationBarItem(
                  icon: SvgPicture.asset(
                    height: 15.h,
                    width: 13.w,
                    imagePath['location_icon'] ?? "",
                    color: selectedIndex == 3
                        ? lightThemeSelectedItemColor
                        : lightThemeWhiteColor,
                  ),
                  selectedColor: lightThemeSelectedItemColor,
                ),
                DotNavigationBarItem(
                  icon: const Icon(Icons.menu),
                  selectedColor: lightThemeSelectedItemColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
