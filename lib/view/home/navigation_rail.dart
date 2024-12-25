import 'package:flutter/material.dart';
import 'package:food_hub_admin/view/home/app_screens.dart';

class NavigationRailScreen extends StatelessWidget {
  final Function(String) onScreenSelected;

  const NavigationRailScreen({super.key, required this.onScreenSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Material(
        elevation: 2,
        child: ListView(
          children: AppScreens.screens.keys.map((screen) {
            return ListTile(
              title: Text(screen),
              onTap: () => onScreenSelected(screen),
            );
          }).toList(),
        ),
      ),
    );
  }
}
