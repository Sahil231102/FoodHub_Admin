import 'package:food_hub_admin/services/firebase_service.dart';
import 'package:get/get.dart';

class DashboardCountController extends GetxController {
  int foodItemCount = 0;
  int userCount = 0;
  bool isLoad = false;

  void toggleLoad(bool value) {
    isLoad = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchFoodItemCount();
    fetchUserCount();
  }

  // Method to fetch the count of food items from Firestore
  Future<void> fetchFoodItemCount() async {
    try {
      final foodItemCollection = FirebaseServices.foodItemsCollection;
      final querySnapshot = await foodItemCollection.get();
      foodItemCount = querySnapshot.size;
      update();
    } catch (e) {
      Get.snackbar("====>ERROR<====", "$e");
    }
  }

  Future<void> fetchUserCount() async {
    try {
      final userCollection = FirebaseServices.userCollection;
      final querySnapshot = await userCollection.get();
      userCount = querySnapshot.size;
      update();
    } catch (e) {
      Get.snackbar("====>ERROR<====", "$e");
    }
  }
}
