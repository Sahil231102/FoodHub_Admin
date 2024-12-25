import 'package:flutter/material.dart';
import 'package:food_hub_admin/view/home/app_screens.dart';

class NavigationDrawer extends StatelessWidget {
  final Function(String) onScreenSelected;

  const NavigationDrawer({super.key, required this.onScreenSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: AppScreens.screens.keys.map((screen) {
          return ListTile(
            title: Text(screen),
            onTap: () => onScreenSelected(screen),
          );
        }).toList(),
      ),
    );
  }
}
