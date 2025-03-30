import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/storage/storage_manager.dart';
import 'package:food_hub_admin/view/auth/login_screen.dart';
import 'package:food_hub_admin/view/home/app_screens.dart';
import 'package:food_hub_admin/view/home/navigation_rail.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Logout",
                      style: AppTextStyle.w700(fontSize: 18),
                    ),
                    content: Text(
                      "Are you sure you want to logout?",
                      style: AppTextStyle.w700(fontSize: 18),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: AppTextStyle.w700(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          StorageManager.saveData("isLoggedIn", false);
                          Get.offAll(() => const LoginScreen());
                        },
                        child: Text(
                          "Logout",
                          style: AppTextStyle.w700(
                              fontSize: 18, color: AppColors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          )
        ],
        title: Text(
          currentScreen,
          style: AppTextStyle.w700(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
        leading: isMobile
            ? IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
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
