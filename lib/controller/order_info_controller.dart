import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // Fetch orders in real-time
  void fetchOrders() {
    _firestore.collection('orders').snapshots().listen((snapshot) {
      orders.value =
          snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList();
    });
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore
        .collection('orders')
        .doc(orderId)
        .update({'status': status});
  }
}

class Order {
  String orderId;
  String address;
  int amount;
  List<Item> items;
  String paymentType;
  String status;
  String userId;

  Order({
    required this.orderId,
    required this.address,
    required this.amount,
    required this.items,
    required this.paymentType,
    required this.status,
    required this.userId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      address: json['address'],
      amount: json['amount'],
      items:
          (json['items'] as List).map((item) => Item.fromJson(item)).toList(),
      paymentType: json['paymentType'],
      status: json['status'],
      userId: json['userId'],
    );
  }
}

class Item {
  String foodId;
  int quantity;
  String total;

  Item({
    required this.foodId,
    required this.quantity,
    required this.total,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      foodId: json['foodId'],
      quantity: json['quantity'],
      total: json['total'],
    );
  }
}
