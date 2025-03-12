import 'package:food_hub_admin/model/user_info.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoController extends GetxController {
  RxList<UserModel> userinfo = <UserModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
  }

  // Fetch user data from Firestore
  Future<void> fetchUserInfo() async {
    try {
      isLoading.value = true;
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      final users = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      userinfo.assignAll(users);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
