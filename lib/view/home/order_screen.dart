import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/controller/order_info_controller.dart';
import 'package:food_hub_admin/view/home/order_info_screen.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(
            () => DataTable(
              dataTextStyle: AppTextStyle.w700(fontSize: 15),
              columnSpacing: 35,
              border: TableBorder.all(color: Colors.black),
              columns: [
                DataColumn(
                    label:
                        Text("Index", style: AppTextStyle.w700(fontSize: 20))),
                DataColumn(
                    label: Text("Order ID",
                        style: AppTextStyle.w700(fontSize: 20))),
                DataColumn(
                    label: Text("No Of Items",
                        style: AppTextStyle.w700(fontSize: 20))),
                DataColumn(
                    label: Text("Payment Type",
                        style: AppTextStyle.w700(fontSize: 20))),
                DataColumn(
                    label: Text("Payment",
                        style: AppTextStyle.w700(fontSize: 20))),
                DataColumn(
                    label: Text("Order Status",
                        style: AppTextStyle.w700(fontSize: 20))),
                DataColumn(
                    label:
                        Text("Action", style: AppTextStyle.w700(fontSize: 20))),
              ],
              rows: List.generate(orderController.orders.length, (index) {
                var order = orderController.orders[index];
                return DataRow(cells: [
                  DataCell(Text((index + 1).toString())),
                  DataCell(Text(order.orderId)),
                  DataCell(Text(order.items.length.toString())),
                  DataCell(Text(order.paymentType)),
                  DataCell(Text("₹ ${order.amount.toString()}")),
                  DataCell(Text(order.status)),
                  DataCell(
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Optional rounded corners
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => OrderInfoScreen(
                              orderId: order.orderId,
                            ));
                      },
                      child: Text(
                        "View",
                        style: AppTextStyle.w700(
                            color: AppColors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ]);
              }),
            ),
          ),
        ),
      ),
    );
  }
}
