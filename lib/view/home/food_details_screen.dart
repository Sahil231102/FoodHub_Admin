import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/controller/image_picker_controller.dart';
import 'package:food_hub_admin/view/home/update_food_item.dart';
import 'package:food_hub_admin/view/widget/common_button.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';

class FoodDetailsScreen extends StatefulWidget {
  final String documentId;

  const FoodDetailsScreen({super.key, required this.documentId});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late Future<DocumentSnapshot> foodDetailsFuture;
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());

  @override
  void initState() {
    super.initState();
    foodDetailsFuture =
        _fireStore.collection('FoodItems').doc(widget.documentId).get();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Food Details",
          style: AppTextStyle.w700(
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: foodDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching food details"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Food details not found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            );
          }

          final foodData = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> images = foodData['image_urls'] ?? [];
          final String foodName = foodData['food_name'] ?? "Unknown";
          final String foodId = foodData['food_id'] ?? "Unknown";

          final String foodPrice = foodData['food_price'] ?? "Unknown";
          final String foodCategory = foodData['food_category'] ?? "Unknown";
          final String foodDescription =
              foodData['food_description'] ?? "No description provided";

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Images:",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
                10.sizeHeight,
                SizedBox(
                  height: screenHeight * 0.5,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600
                          ? 2
                          : 5, // Adjust columns based on screen width
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final String image = images[index];

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(image),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                20.sizeHeight,
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(screenWidth < 600 ? 3 : 2),
                    1: FlexColumnWidth(screenWidth < 600 ? 4 : 3),
                  },
                  border: TableBorder.all(color: Colors.grey, width: 1),
                  children: [
                    _buildTableRow("Food Name:", foodName),
                    _buildTableRow("Food Price:", "₹$foodPrice"),
                    _buildTableRow("Food Category:", foodCategory),
                    _buildTableRow("Description:", foodDescription),
                    _buildTableRow(
                        "uploaded_at:",
                        foodData['uploaded_at']?.toDate().toString() ??
                            "Unknown"),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "",
                            style: AppTextStyle.w700(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 220, // Fixed width
                            height: 50, // Fixed height
                            child: Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Optional rounded corners
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() => UpdateItemScreen(
                                        foodId: foodId,
                                        initialName: foodName,
                                        initialPrice: foodPrice,
                                        initialCategory: foodCategory,
                                        initialDescription: foodDescription,
                                        initialImages: List<String>.from(
                                            images))); // ✅ Convert dynamic list to List<String>
                                  },
                                  child: Text(
                                    "Update",
                                    style: AppTextStyle.w700(
                                        color: AppColors.white, fontSize: 18),
                                  ),
                                ),
                                10.sizeWidth,
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Optional rounded corners
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Delete Food Item",
                                      content: Column(
                                        children: [
                                          const Text(
                                              "Are you sure you want to delete this food item?"),
                                          20.sizeHeight,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CommonButton(
                                                text: "Cancel",
                                                onTap: () {
                                                  Get.back();
                                                },
                                              ),
                                              CommonButton(
                                                text: "Delete",
                                                onTap: () {
                                                  imagePickerController
                                                      .removeItem(
                                                          foodId: foodId);
                                                  Get.back();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Remove",
                                    style: AppTextStyle.w700(
                                        color: AppColors.white, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: AppTextStyle.w700(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: AppTextStyle.w600(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
