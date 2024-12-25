import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/Images.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/controller/image_picker_controller.dart';
import 'package:food_hub_admin/view/home/food_details_screen.dart';
import 'package:food_hub_admin/view/home/side_menu.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';

class ShowItemScreen extends StatefulWidget {
  const ShowItemScreen({super.key});

  @override
  State<ShowItemScreen> createState() => _ShowItemScreenState();
}

class _ShowItemScreenState extends State<ShowItemScreen> {
  final ImagePickerController imagePickerController = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Show Food Items",
          style: AppTextStyle.w700(
            fontSize: 20,
          ),
        ),
      ),
      body: GetBuilder<ImagePickerController>(
        builder: (controller) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('FoodItems').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 50),
                      const SizedBox(height: 20),
                      Text(
                        "Error loading data. Please try again later.",
                        style: AppTextStyle.w700(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
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
                        "No Food Items. Add Food Item.",
                        style: AppTextStyle.w700(fontSize: 20),
                      ),
                    ],
                  ),
                );
              }

              final List<DocumentSnapshot> foodItems = snapshot.data!.docs;

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  final food = foodItems[index];
                  final foodId = food['food_id'];
                  final String foodName = food['food_name'] ?? 'No Name';
                  final String foodCategory = food['food_category'] ?? 'No Category';
                  final String foodPrice = food['food_price'] ?? '0';
                  final List<dynamic> base64Images = food['images'] ?? [];

                  Uint8List? firstImageBytes;
                  if (base64Images.isNotEmpty) {
                    try {
                      firstImageBytes = base64Decode(base64Images[0] as String);
                    } catch (e) {
                      GetSnackBar(
                        title: "$e",
                      );
                    }
                  }
                  return SizedBox(
                    height: 150,
                    width: 100,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
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
                                      firstImageBytes,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/placeholder.png',
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
                                    child: Text(
                                      foodCategory,
                                      style: AppTextStyle.w700(fontSize: 20),
                                    ),
                                  ),
                                  Text(
                                    "Price: ₹$foodPrice",
                                    style: AppTextStyle.w700(
                                      fontSize: 20,
                                      color: AppColors.green,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        fixedSize: const Size(210, 50)),
                                    onPressed: () {
                                      Get.to(() => FoodDetailsScreen(
                                            documentId: foodId,
                                          ));
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        fixedSize: const Size(210, 50)),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: AppTextStyle.w700(fontSize: 18),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  controller.removeItem(foodId: foodId);
                                                  Get.back();
                                                },
                                                child: Text(
                                                  'Remove',
                                                  style: AppTextStyle.w700(
                                                      fontSize: 18, color: Colors.red),
                                                ),
                                              ),
                                            ],
                                            content: Text(
                                              "Are you sure you want to remove this item?",
                                              style: AppTextStyle.w700(fontSize: 18),
                                            ),
                                            title: Text(
                                              "Remove Item",
                                              style: AppTextStyle.w700(
                                                fontSize: 25,
                                                color: Colors.black,
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.cancel,
                                          color: AppColors.white,
                                        ),
                                        30.sizeWidth,
                                        Text(
                                          "Remove",
                                          style: AppTextStyle.w700(
                                            fontSize: 20,
                                            color: AppColors.white,
                                          ),
                                        ),
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
          );
        },
      ),
    );
  }
}
