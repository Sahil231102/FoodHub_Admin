import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';

class FoodDetailsScreen extends StatefulWidget {
  final String documentId; // Accept documentId as a parameter

  const FoodDetailsScreen({super.key, required this.documentId});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<DocumentSnapshot> foodDetailsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the food details using the documentId
    foodDetailsFuture = _firestore.collection('FoodItems').doc(widget.documentId).get();
  }

  @override
  Widget build(BuildContext context) {
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

          // Check if data exists
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

          // Extract data from the snapshot
          final foodData = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> images = foodData['images'] ?? [];
          final String foodName = foodData['food_name'] ?? "Unknown";
          final String foodPrice = foodData['food_price'] ?? "Unknown";
          final String foodCategory = foodData['food_category'] ?? "Unknown";
          final String foodDescription = foodData['food_description'] ?? "No description provided";

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Images:",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 320,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: images.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final String base64Image = images[index];
                      final decodedImage = base64Decode(base64Image);

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(decodedImage),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  border: TableBorder.all(color: Colors.grey, width: 1),
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Food Name:",
                            style: AppTextStyle.w700(fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            foodName,
                            style: AppTextStyle.w600(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Food Price:",
                            style: AppTextStyle.w700(fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "₹$foodPrice",
                            style: AppTextStyle.w600(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Food Category:",
                            style: AppTextStyle.w700(fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            foodCategory,
                            style: AppTextStyle.w600(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Description:",
                            style: AppTextStyle.w700(fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            foodDescription,
                            style: AppTextStyle.w600(fontSize: 20),
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
}
