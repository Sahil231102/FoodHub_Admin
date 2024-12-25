import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardCountController extends GetxController {
  var foodItemCount = 0;
  var userCount = 0;

  @override
  void onInit() {
    super.onInit();
    fetchFoodItemCount();
    fetchUserCount();
  }

  // Method to fetch the count of food items from Firestore
  void fetchFoodItemCount() async {
    try {
      final foodItemCollection = FirebaseFirestore.instance.collection('FoodItems');
      final querySnapshot = await foodItemCollection.get();

      foodItemCount = querySnapshot.size;
      update();
    } catch (e) {
      Get.snackbar("====>ERROR<====", "$e");
    }
  }

  void fetchUserCount() async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('user');
      final querySnapshot = await userCollection.get();
      userCount = querySnapshot.size;
    } catch (e) {
      Get.snackbar("====>ERROR<====", "$e");
    }
  }
}
