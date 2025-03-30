import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/Images.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/controller/dashboard_count_controller.dart';
import 'package:food_hub_admin/services/firebase_service.dart';
import 'package:food_hub_admin/view/home/food_details_screen.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/dashboard_common_counter_button.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardCountController _dashboardCountController =
      Get.put(DashboardCountController());

  late List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    loadInitData();
  }

  Future<void> loadInitData() async {
    _dashboardCountController.toggleLoad(true);
    await _dashboardCountController.fetchUserCount();
    await _dashboardCountController.fetchFoodItemCount();
    await _dashboardCountController.fetchOrderCount();
    await _dashboardCountController.fetchTotalAmount();

    _dashboardCountController.toggleLoad(false);

    data = [
      {
        "nameText": "Total Order",
        "countText": "${_dashboardCountController.orderCount}",
        "color": Colors.pink
      },
      {
        "nameText": "Total Payment",
        "countText": "₹ ${_dashboardCountController.totalAmount}",
        "color": Colors.black
      },
      {
        "nameText": "Total Menu Item",
        "countText": "${_dashboardCountController.foodItemCount}",
        "color": Colors.purpleAccent,
      },
      {
        "nameText": "Total Customers",
        "countText": "${_dashboardCountController.userCount}",
        "color": Colors.red,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardCountController>(
      builder: (controller) {
        if (controller.isLoad) {
          return const Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWeb = constraints.maxWidth > 600;

            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Wrap(
                          spacing: isWeb ? 20 : 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            data.length,
                            (index) {
                              final item = data[index];
                              return DashboardCommonCounterButton(
                                nameText: item["nameText"],
                                countText: item["countText"],
                                colors: item["color"],
                              );
                            },
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream:
                              FirebaseServices.foodItemsCollection.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("Error loading data."));
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Column(
                                  children: [
                                    const Image(
                                      image: AssetImage(AppImages.notFoundFood),
                                      height: 420,
                                      width: 400,
                                    ),
                                    Text(
                                      "No Food Items. Add Food Item.",
                                      style: AppTextStyle.w700(fontSize: 20),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final List<DocumentSnapshot> foodItems =
                                snapshot.data!.docs;

                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: foodItems.length,
                              itemBuilder: (context, index) {
                                final food = foodItems[index];
                                final String foodName =
                                    food['food_name'] ?? 'No Name';
                                final String foodCategory =
                                    food['food_category'] ?? 'No Category';
                                final String foodPrice =
                                    food['food_price'] ?? '0';
                                final List<dynamic> imageUrls =
                                    food['image_urls'] ??
                                        []; // Corrected field name

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: imageUrls.isNotEmpty
                                              ? Image.network(
                                                  imageUrls
                                                      .first, // Show first image from Firestore
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'assets/placeholder.png', // Placeholder if no image found
                                                  width: 80,
                                                  height: 80,
                                                ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(foodName,
                                                  style: AppTextStyle.w700(
                                                      fontSize: 18)),
                                              Text(foodCategory,
                                                  style: AppTextStyle.w700(
                                                      fontSize: 14)),
                                              Text(
                                                "Price: ₹$foodPrice",
                                                style: AppTextStyle.w700(
                                                    color: AppColors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Optional rounded corners
                                              ),
                                              backgroundColor:
                                                  AppColors.primary),
                                          onPressed: () => Get.to(() =>
                                              FoodDetailsScreen(
                                                  documentId: food['food_id'])),
                                          child: Text(
                                            "View",
                                            style: AppTextStyle.w700(
                                                color: AppColors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
