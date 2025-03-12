import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/controller/flutter_image_compress.dart';
import 'package:food_hub_admin/services/cloudinary_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CategoryController extends GetxController {
  final ImagePicker picker = ImagePicker();
  XFile? selectedImage;
  bool loading = false;

  Future<void> pickImage() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      selectedImage = image;
      update();
    }
  }

  void removeImage() {
    selectedImage = null;
    update();
  }

  Future<void> uploadCategoryToFirestore({
    required String categoryName,
    required BuildContext context,
  }) async {
    if (selectedImage == null || categoryName.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Category name and image are required.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      loading = true;
      update();

      // Read and compress the image
      final Uint8List bytes = await selectedImage!.readAsBytes();
      final Uint8List? compressedBytes =
          await ImageCompressorUtil.compressImage(bytes);

      if (compressedBytes == null) {
        throw Exception("Failed to compress image");
      }

      // Upload to Cloudinary
      final String? imageUrl =
          await CloudinaryService.uploadImage(compressedBytes);

      if (imageUrl == null) {
        throw Exception("Failed to upload image to Cloudinary");
      }

      // Create document in Firestore
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('food_categories').doc();

      String documentId = docRef.id;

      await docRef.set({
        'category_id': documentId,
        'category_name': categoryName.trim(),
        'image_url': imageUrl, // Store the Cloudinary URL instead of base64
        'uploaded_at': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        "Success",
        "Category added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      selectedImage = null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding category: $e")),
      );
    } finally {
      loading = false;
      update();
    }
  }
}
