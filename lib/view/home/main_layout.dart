import 'package:flutter/material.dart';
import 'package:food_hub_admin/view/home/app_screens.dart';
import 'package:food_hub_admin/view/home/navigation_rail.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String currentScreen = 'Dashboard';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          currentScreen,
          style: AppTextStyle.w700(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
        leading: isMobile
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
              )
            : null,
      ),
      drawer: isMobile
          ? NavigationRailScreen(
              onScreenSelected: (screen) {
                setState(() => currentScreen = screen);
                scaffoldKey.currentState?.closeDrawer();
              },
            )
          : null,
      body: Row(
        children: [
          // Side navigation for desktop
          if (!isMobile)
            NavigationRailScreen(
              onScreenSelected: (screen) {
                setState(() => currentScreen = screen);
              },
            ),
          // Content area
          Expanded(
            child: AppScreens.screens[currentScreen] ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
