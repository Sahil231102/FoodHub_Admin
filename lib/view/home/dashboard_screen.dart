import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/Images.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/home/side_menu.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/dashboard_common_counter_button.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data for demonstration
  final List<Map<String, dynamic>> foodItems = [
    {
      "image": AppImages.food,
      "name": "Burger",
      "price": 120,
      "category": "Fast Food",
    },
    {
      "image": AppImages.food,
      "name": "Pizza",
      "price": 250,
      "category": "Italian",
    },
    {
      "image": AppImages.food,
      "name": "Pasta",
      "price": 180,
      "category": "Italian",
    },
    {
      "image": AppImages.food,
      "name": "Sandwich",
      "price": 90,
      "category": "Snacks",
    },
    {
      "image": AppImages.food,
      "name": "Noodles",
      "price": 150,
      "category": "Chinese",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Dashboard",
          style: AppTextStyle.w700(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardCommonCounterButton(
                  nameText: "Total Order",
                  countText: "120",
                  colors: Colors.pink,
                ),
                const DashboardCommonCounterButton(
                  nameText: "Total Payment",
                  countText: "15000",
                  colors: Colors.black,
                ),
                DashboardCommonCounterButton(
                  nameText: "Total Menu Item",
                  countText: "120",
                  nameTextColor: AppColors.black,
                  countTextColor: AppColors.black,
                  colors: Colors.amberAccent.shade100,
                ),
                DashboardCommonCounterButton(
                  nameText: "Total Customers",
                  countText: "5",
                ),
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final food = foodItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8), // Add spacing
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            food["image"],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              100.sizeHeight,
                              Text(
                                food["name"],
                                style: AppTextStyle.w700(fontSize: 20),
                              ),
                              8.sizeHeight,
                              Text(
                                "Category: ${food["category"]}",
                                style: AppTextStyle.w600(fontSize: 16),
                              ),
                              8.sizeHeight,
                              Text(
                                "Price: ₹${food["price"]}",
                                style: AppTextStyle.w600(
                                    fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
