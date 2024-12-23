import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/Images.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/home/food_details_screen.dart';
import 'package:food_hub_admin/view/home/side_menu.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/dashboard_common_counter_button.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data for demonstration

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Row(
                children: [
                  Text(
                    "FoodImages",
                    style: AppTextStyle.w700(fontSize: 20),
                  ),
                  130.sizeWidth,
                  Text(
                    "FoodName",
                    style: AppTextStyle.w700(fontSize: 20),
                  ),
                  120.sizeWidth,
                  Text(
                    "FoodCategory",
                    style: AppTextStyle.w700(fontSize: 20),
                  ),
                  140.sizeWidth,
                  Text(
                    "FoodPrice",
                    style: AppTextStyle.w700(fontSize: 20),
                  ),
                  200.sizeWidth,
                  Text(
                    "Action",
                    style: AppTextStyle.w700(fontSize: 20),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('FoodItems').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading data."));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Column(
                    children: [
                      const Image(
                        image: AssetImage(AppImages.notFoundFood),
                        height: 420,
                        width: 400,
                      ),
                      Text(
                        "Not Food Items. Add Food Item.",
                        style: AppTextStyle.w700(fontSize: 20),
                      )
                    ],
                  ));
                }

                final List<DocumentSnapshot> foodItems = snapshot.data!.docs;

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    final food = foodItems[index];
                    final food_id = food['food_id'];
                    final String foodName = food['food_name'] ?? 'No Name';
                    final String foodCategory = food['food_category'] ?? 'No Category';
                    final String foodPrice = food['food_price'] ?? '0';
                    final List<dynamic> base64Images = food['images'] ?? [];

                    Uint8List? firstImageBytes;
                    if (base64Images.isNotEmpty) {
                      try {
                        firstImageBytes = base64Decode(base64Images[0]) as Uint8List?;
                      } catch (e) {
                        print("Error decoding image: $e");
                      }
                    }

                    return SizedBox(
                      height: 150,
                      width: 100,
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 90, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: firstImageBytes != null
                                    ? Image.memory(
                                        firstImageBytes as Uint8List,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/placeholder.png', // Fallback placeholder image
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      foodName,
                                      style: AppTextStyle.w700(fontSize: 20),
                                    ),
                                    Center(
                                        child: Text("$foodCategory",
                                            style: AppTextStyle.w700(fontSize: 20))),
                                    Text("Price: ₹$foodPrice",
                                        style: AppTextStyle.w700(
                                            fontSize: 20, color: AppColors.green)),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          fixedSize: Size(180, 50)),
                                      onPressed: () {
                                        Get.to(() => FoodDetailsScreen(
                                              documentId: food_id,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.view_agenda_outlined,
                                            color: AppColors.white,
                                          ),
                                          30.sizeWidth,
                                          Text(
                                            "View",
                                            style: AppTextStyle.w700(
                                              fontSize: 20,
                                              color: AppColors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
