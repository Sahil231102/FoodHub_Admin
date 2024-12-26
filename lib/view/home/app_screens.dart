import 'package:flutter/material.dart';
import 'package:food_hub_admin/view/home/add_item_screen.dart';
import 'package:food_hub_admin/view/home/dashboard_screen.dart';
import 'package:food_hub_admin/view/home/order_screen.dart';
import 'package:food_hub_admin/view/home/show_item_screen.dart';

class AppScreens {
  static final Map<String, Widget> screens = {
    'Dashboard': const DashboardScreen(),
    'Order': const OrderScreen(),
    'Add Item': const AddItemScreen(),
    'Profile': const Placeholder(),
    'Show Item': const ShowItemScreen(),
    'User Information': const Placeholder(),
    'Payment': const Placeholder(),
  };
}
