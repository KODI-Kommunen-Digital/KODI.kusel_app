import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/screens/category/category_screen.dart';
import 'package:kusel/screens/search/search_screen.dart';

import '../../images_path.dart';
import '../../theme_manager/colors.dart';
import '../home/home_screen.dart';
import '../home/home_screen_provider.dart';
import '../location/location_screen.dart';
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
    CategoryScreen(),
    SearchScreen(),
    LocationScreen(),
    SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardScreenProvider.notifier).getLoginStatus();
    });
  }

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
              backgroundColor: Theme.of(context).colorScheme.secondary,
              selectedItemColor: Theme.of(context).indicatorColor,
              unselectedItemColor:  Theme.of(context).canvasColor,
              currentIndex: selectedIndex,
              enableFloatingNavBar: true,
              paddingR: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              marginR: const EdgeInsets.all(0),
              onTap: ref.read(dashboardScreenProvider.notifier).onIndexChanged,
              dotIndicatorColor: Theme.of(context).indicatorColor,
              itemPadding:
                  const EdgeInsets.only(top: 8, bottom: 0, left: 16, right: 16),
              items: [
                DotNavigationBarItem(
                  icon: const Icon(Icons.home_filled),
                  selectedColor: Theme.of(context).indicatorColor,
                ),
                DotNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SvgPicture.asset(
                      height: 13.h,
                      width: 13.w,
                      imagePath['discover_icon'] ?? "",
                      color: selectedIndex == 1
                          ? Theme.of(context).indicatorColor
                          :  Theme.of(context).canvasColor,
                    ),
                  ),
                  selectedColor: Theme.of(context).indicatorColor,
                ),
                DotNavigationBarItem(
                  icon: const Icon(Icons.search),
                  selectedColor: Theme.of(context).indicatorColor,
                ),
                DotNavigationBarItem(
                  icon: SvgPicture.asset(
                    height: 15.h,
                    width: 13.w,
                    imagePath['location_icon'] ?? "",
                    color: selectedIndex == 3
                        ? Theme.of(context).indicatorColor
                        :  Theme.of(context).canvasColor,
                  ),
                  selectedColor: Theme.of(context).indicatorColor,
                ),
                DotNavigationBarItem(
                  icon: const Icon(Icons.menu),
                  selectedColor: Theme.of(context).indicatorColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
