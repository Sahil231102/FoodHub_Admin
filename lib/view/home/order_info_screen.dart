import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderInfoController extends GetxController {
  final String orderId;
  var orderData = {}.obs;
  var userData = {}.obs;
  var isLoading = true.obs;

  OrderInfoController(this.orderId);

  @override
  void onInit() {
    super.onInit();
    fetchOrderData();
  }

  void fetchOrderData() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();
      if (doc.exists) {
        orderData.value = doc.data() ?? {};
        // Fetch user details
        fetchUserData(orderData['userId']);
      }
    } catch (e) {
      print('Error fetching order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchUserData(String userId) async {
    try {
      var doc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();
      if (doc.exists) {
        userData.value = doc.data() ?? {};
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<Map<String, dynamic>?> getFoodItem(String foodId) async {
    var doc = await FirebaseFirestore.instance
        .collection('FoodItems')
        .doc(foodId)
        .get();
    return doc.data();
  }

  void updateOrderStatus(String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      orderData['status'] = newStatus;
      orderData.refresh();
      Get.snackbar('', 'Order status updated to $newStatus',
          titleText:
              Text('Success', style: AppTextStyle.w700(color: Colors.white)),
          messageText: Text('Order status updated to $newStatus',
              style: AppTextStyle.w600(color: Colors.white)),
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> sendOrderConfirmationNotification() async {
    String? fcmToken =
        userData['fcmToken']; // Retrieve FCM Token from Firestore
    if (fcmToken == null || fcmToken.isEmpty) {
      print('FCM Token not found for user');
      return;
    }

    const String serverKey =
        'BN61OEKqf_cyzZ-yVeZ1x1N9uVPj4XtWTv2rkzg_zDpmTgN7EwYW5wYn2Eg6Wi0T5QaMZcTE3MurpMFSiuDc19k'; // Replace with your Firebase Cloud Messaging server key
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final Map<String, dynamic> notificationData = {
      "to": fcmToken,
      "notification": {
        "title": "Order Confirmed ✅",
        "body": "Your order #$orderId has been confirmed!",
        "sound": "default"
      },
      "data": {"orderId": orderId, "status": "Confirmed"}
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: jsonEncode(notificationData),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}

class OrderInfoScreen extends StatelessWidget {
  final String orderId;
  const OrderInfoScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderInfoController(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: AppTextStyle.w700(color: AppColors.black, fontSize: 20),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orderData.isEmpty) {
          return Center(
            child: Text(
              'No Order Found',
              style: AppTextStyle.w700(fontSize: 18, color: Colors.red),
            ),
          );
        }

        var data = controller.orderData;
        var user = controller.userData;

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order ID: ${controller.orderId}',
                  style: AppTextStyle.w700(fontSize: 18)),
              const SizedBox(height: 16),

              // User Info
              Text(
                'User Info:',
                style:
                    AppTextStyle.w700(fontSize: 18, color: AppColors.primary),
              ),
              Text('Name: ${user['name'] ?? 'N/A'}',
                  style: AppTextStyle.w600(fontSize: 16)),
              Text('Phone: ${user['mobile_number'] ?? 'N/A'}',
                  style: AppTextStyle.w600(fontSize: 16)),
              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  columnWidths: const {
                    0: FixedColumnWidth(100),
                    1: FixedColumnWidth(250),
                    2: FixedColumnWidth(150),
                    3: FixedColumnWidth(150),
                  },
                  children: [
                    // Table Header
                    TableRow(
                      decoration: const BoxDecoration(color: AppColors.primary),
                      children: [
                        _buildTableHeader('Image'),
                        _buildTableHeader('Name'),
                        _buildTableHeader('Quantity'),
                        _buildTableHeader('Price'),
                      ],
                    ),
                    // Table Rows
                    ...data['items'].map<TableRow>((item) {
                      return TableRow(
                        children: [
                          _buildImageCell(controller, item['foodId']),
                          _buildTextCell(
                            controller,
                            item['foodId'],
                            'food_name',
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${item['quantity']}',
                                style: AppTextStyle.w600(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          _buildTextCell(
                            controller,
                            item['foodId'],
                            'food_price',
                            prefix: '₹',
                          ),
                        ],
                      );
                    }).toList(),

                    // Total Row
                    TableRow(
                      children: [
                        const SizedBox(), // Empty cell for Image
                        const SizedBox(), // Empty cell for Name
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total:',
                            style: AppTextStyle.w700(
                                fontSize: 16, color: AppColors.primary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '₹${data['amount'] ?? '0.00'}',
                            style: AppTextStyle.w700(
                                fontSize: 16, color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text('Address: ${data['address'] ?? 'N/A'}',
                  style: AppTextStyle.w600(fontSize: 16)),
              const SizedBox(height: 16),

              // Status with Confirm button

              Text('Total: ₹${data['amount'] ?? '0.00'}',
                  style: AppTextStyle.w700(fontSize: 16, color: Colors.green)),
              10.sizeHeight,
              Text('Status: ${data['status'] ?? 'Pending'}',
                  style: AppTextStyle.w600(fontSize: 16)),
              10.sizeHeight,
              Row(
                children: [
                  if (data['status'] == "Pending")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Optional rounded corners
                        ),
                      ),
                      onPressed: () {
                        controller.updateOrderStatus('Confirmed');
                      },
                      child: Text(
                        'Confirm Order',
                        style: AppTextStyle.w700(
                            color: AppColors.white, fontSize: 18),
                      ),
                    ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTableHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Text(
          title,
          style: AppTextStyle.w700(color: AppColors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTextCell(
    OrderInfoController controller,
    String foodId,
    String key, {
    String prefix = '',
  }) {
    return FutureBuilder(
      future: controller.getFoodItem(foodId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Icon(Icons.error, color: Colors.red);
        }
        var foodData = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$prefix${foodData?[key] ?? 'N/A'}',
            style: AppTextStyle.w600(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildImageCell(OrderInfoController controller, String foodId) {
    return FutureBuilder(
      future: controller.getFoodItem(foodId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Icon(Icons.error, color: Colors.red);
        }
        var foodData = snapshot.data;
        var imageUrls = foodData?['image_urls'];

        if (imageUrls is List && imageUrls.isNotEmpty) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image:
                          DecorationImage(image: NetworkImage(imageUrls[0]))),
                ),
              ));
        } else {
          return const Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey));
        }
      },
    );
  }
}
