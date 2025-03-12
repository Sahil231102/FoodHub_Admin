import 'package:flutter/material.dart';
import 'package:food_hub_admin/view/home/add_category_screen.dart';
import 'package:food_hub_admin/view/home/add_item_screen.dart';
import 'package:food_hub_admin/view/home/dashboard_screen.dart';
import 'package:food_hub_admin/view/home/order_screen.dart';
import 'package:food_hub_admin/view/home/show_category_screen.dart';
import 'package:food_hub_admin/view/home/show_item_screen.dart';
import 'package:food_hub_admin/view/home/user_information_screen.dart';

class AppScreens {
  static final Map<String, Widget> screens = {
    'Dashboard': const DashboardScreen(),
    'Orders': const OrderScreen(),
    'Add New Item': const AddItemScreen(),
    'All Items': const ShowItemScreen(),
    'Add Category': AddCategoryScreen(),
    'Manage Categories': const ShowCategoryScreen(),
    'User': const UserInformationScreen(),
    'Transactions': const Placeholder(),
    'Profile': const Placeholder(),
  };
}
