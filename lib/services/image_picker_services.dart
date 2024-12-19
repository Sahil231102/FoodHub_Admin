import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/widget/app_default_dialog.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService extends GetxController {
  final ImagePicker picker = ImagePicker();

  // Function to pick an image and upload it along with food details to Firestore
  Future<void> pickAndUploadFoodDetails({
    required BuildContext context,
    required String foodName,
    required String foodPrice,
    required String foodCategory,
    required String foodDescription,
  }) async {
    try {
      // Pick an image
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Convert the picked image to bytes
        final Uint8List bytes = await pickedFile.readAsBytes();

        // Convert the bytes to base64 string
        final String base64Image = base64Encode(bytes);

        // Generate a unique document ID
        String uniqueID =
            FirebaseFirestore.instance.collection('FoodItems').doc().id;

        // Upload the image and food details to Firestore under the same document ID
        await uploadFoodDetailsToFirestore(
          uniqueID: uniqueID,
          base64Image: base64Image,
          foodName: foodName,
          foodPrice: foodPrice,
          foodCategory: foodCategory,
          foodDescription: foodDescription,
        );

        Get.defaultDialog(
          title: "Success",
          titleStyle: AppTextStyle.w700(color: AppColors.black, fontSize: 20),
          middleText: "Successfully Added Item",
          middleTextStyle:
              AppTextStyle.w700(color: AppColors.black, fontSize: 20),
          backgroundColor: AppColors.white,
          radius: 10,
          contentPadding: EdgeInsets.all(20),
          confirm: ElevatedButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text(
              "OK",
              style: AppTextStyle.w700(fontSize: 16, color: AppColors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      _showError(context, 'Error picking image: $e');
    }
  }

  // Function to upload food details along with image to Firestore
  Future<void> uploadFoodDetailsToFirestore({
    required String uniqueID,
    required String base64Image,
    required String foodName,
    required String foodPrice,
    required String foodCategory,
    required String foodDescription,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('FoodItems')
          .doc(uniqueID)
          .set({
        'foodName': foodName.trim(),
        'foodPrice': foodPrice.trim(),
        'foodCategory': foodCategory.trim(),
        'foodDescription': foodDescription.trim(),
        'imageBase64': base64Image,
        'uploaded_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding food item: $e");
    }
  }

  // Function to display error messages
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
