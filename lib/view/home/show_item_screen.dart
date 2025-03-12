import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/Images.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/controller/image_picker_controller.dart';
import 'package:food_hub_admin/services/firebase_service.dart';
import 'package:food_hub_admin/view/home/food_details_screen.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
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
      body: GetBuilder<ImagePickerController>(
        builder: (controller) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseServices.foodItemsCollection // Ensures oldest first, newest last
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 50),
                      SizedBox(height: 20),
                      Text(
                        "Error loading data. Please try again later.",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      Text("No Food Items. Add Food Item.", style: AppTextStyle.w700(fontSize: 20)),
                    ],
                  ),
                );
              }

              final List<DocumentSnapshot> foodItems = snapshot.data!.docs;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DataTable(
                        border: TableBorder.all(color: Colors.black),
                        dataTextStyle: AppTextStyle.w700(fontSize: 18),
                        columns: [
                          DataColumn(
                              label: Text(
                            "Index",
                            style: AppTextStyle.w700(fontSize: 20),
                          )),
                          DataColumn(
                              label: Text(
                            "Image",
                            style: AppTextStyle.w700(fontSize: 20),
                          )),
                          DataColumn(
                              label: Text(
                            "Food Name",
                            style: AppTextStyle.w700(fontSize: 20),
                          )),
                          DataColumn(
                              label: Text(
                            "Category",
                            style: AppTextStyle.w700(fontSize: 20),
                          )),
                          DataColumn(
                              label: Text(
                            "Price",
                            style: AppTextStyle.w700(fontSize: 20),
                          )),
                          DataColumn(
                              label: Text(
                            "Actions",
                            style: AppTextStyle.w700(fontSize: 20),
                          )),
                        ],
                        rows: foodItems.asMap().entries.map((entry) {
                          final itemIndex = entry.key + 1;
                          final food = entry.value;
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

                          return DataRow(cells: [
                            DataCell(Text(itemIndex.toString())),
                            DataCell(
                              firstImageBytes != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: MemoryImage(
                                                  firstImageBytes,
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                    )
                                  : const Image(
                                      image: AssetImage('assets/placeholder.png'),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            DataCell(
                              Text(
                                foodName,
                              ),
                            ),
                            DataCell(
                              Text(
                                foodCategory,
                              ),
                            ),
                            DataCell(
                              Text(
                                "₹$foodPrice",
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      Get.to(() => FoodDetailsScreen(documentId: foodId));
                                    },
                                    child: Text(
                                      "View",
                                      style:
                                          AppTextStyle.w700(fontSize: 18, color: AppColors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.black,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Remove Item",
                                              style: AppTextStyle.w700(fontSize: 18),
                                            ),
                                            content: Text(
                                              "Are you sure you want to remove this item?",
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
                                                  controller.removeItem(foodId: foodId);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Remove",
                                                  style: AppTextStyle.w700(
                                                      fontSize: 18, color: AppColors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Remove",
                                      style:
                                          AppTextStyle.w700(fontSize: 18, color: AppColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
