import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';

class Order {
  final int index;
  final String foodImage;
  final String username;
  final String foodname;
  final String orderId;
  final int noOfItems;
  final String paymentType;
  final double payment;
  final String date;

  Order({
    required this.index,
    required this.foodImage,
    required this.username,
    required this.foodname,
    required this.orderId,
    required this.noOfItems,
    required this.paymentType,
    required this.payment,
    required this.date,
  });
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<Order> orders = [
    Order(
      index: 1,
      foodImage:
          'https://t4.ftcdn.net/jpg/06/65/75/07/360_F_665750708_FhXMnTL7Zwe9TNqCWfy9mVOJz3INqmqN.jpg',
      username: 'John Doe',
      foodname: 'Burger',
      orderId: 'ORD123',
      noOfItems: 3,
      paymentType: 'Card',
      payment: 25.99,
      date: '2024-12-25',
    ),
    Order(
      index: 2,
      foodImage:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Pizza-3007395.jpg/1200px-Pizza-3007395.jpg',
      username: 'Jane Smith',
      foodname: 'Pizza',
      orderId: 'ORD124',
      noOfItems: 2,
      paymentType: 'Cash',
      payment: 15.50,
      date: '2024-12-24',
    ),
    Order(
      index: 3,
      foodImage:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Pizza-3007395.jpg/1200px-Pizza-3007395.jpg',
      username: 'Jane Smith',
      foodname: 'Pizza',
      orderId: 'ORD124',
      noOfItems: 2,
      paymentType: 'Cash',
      payment: 15.50,
      date: '2024-12-24',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: DataTable(
            dataTextStyle: AppTextStyle.w700(fontSize: 15),
            columnSpacing: 35,
            border: TableBorder.all(color: Colors.black),
            columns: [
              DataColumn(
                label: Text(
                  "Index",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "Food Image",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "Food Name",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "User Name",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "Order ID",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "No Of Items",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "Payment Type",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "Payment",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "Date",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "Order Status",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  "Action",
                  style: AppTextStyle.w700(fontSize: 20),
                ),
              ),
            ],
            rows: orders.map((order) {
              return DataRow(cells: [
                DataCell(Text(order.index.toString())),
                DataCell(Image.network(order.foodImage, height: 150, width: 150)),
                DataCell(Text(order.foodname)),
                DataCell(Text(order.username)),
                DataCell(Text(order.orderId)),
                DataCell(Text(order.noOfItems.toString())),
                DataCell(Text(order.paymentType)),
                DataCell(Text(order.payment.toStringAsFixed(2))),
                DataCell(Text(order.date)),
                DataCell(GestureDetector(
                  child: Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      "Confirm  ",
                      style: AppTextStyle.w400(fontSize: 15, color: AppColors.white),
                    )),
                  ),
                )),
                DataCell(GestureDetector(
                  child: Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      "View",
                      style: AppTextStyle.w400(fontSize: 15, color: AppColors.white),
                    )),
                  ),
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
