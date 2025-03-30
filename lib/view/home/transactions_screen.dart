import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No transactions available.'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var orders = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(
                  color: Colors.black,
                  width: 1.0,
                  borderRadius: BorderRadius.circular(5),
                ),
                columns: [
                  DataColumn(
                      label: Text('Index',
                          style: AppTextStyle.w700(
                              color: AppColors.black, fontSize: 18))),
                  DataColumn(
                      label: Text('Order ID',
                          style: AppTextStyle.w700(
                              color: AppColors.black, fontSize: 18))),
                  DataColumn(
                      label: Text('Username',
                          style: AppTextStyle.w700(
                              color: AppColors.black, fontSize: 18))),
                  DataColumn(
                      label: Text('Payment Type',
                          style: AppTextStyle.w700(
                              color: AppColors.black, fontSize: 18))),
                  DataColumn(
                      label: Text('Payment ID',
                          style: AppTextStyle.w700(
                              color: AppColors.black, fontSize: 18))),
                  DataColumn(
                      label: Text('Amount',
                          style: AppTextStyle.w700(
                              color: AppColors.black, fontSize: 18))),
                ],
                rows: List.generate(orders.length, (index) {
                  var order = orders[index];
                  var data = order.data() as Map<String, dynamic>;

                  return DataRow(cells: [
                    DataCell(Text('${index + 1}',
                        style: AppTextStyle.w700(
                            color: AppColors.black, fontSize: 18))),
                    DataCell(Text(order.id,
                        style: AppTextStyle.w700(
                            color: AppColors.black, fontSize: 18))), // Order ID
                    DataCell(FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('user')
                          .doc(data['userId'])
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...',
                              style: AppTextStyle.w700(
                                  color: AppColors.black, fontSize: 18));
                        }
                        if (!userSnapshot.hasData ||
                            !userSnapshot.data!.exists) {
                          return const Text('Unknown User');
                        }
                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        return Text(userData['name'] ?? 'Unknown',
                            style: AppTextStyle.w700(
                                color: AppColors.black, fontSize: 18));
                      },
                    )),
                    DataCell(Text(data['paymentType'] ?? 'N/A',
                        style: AppTextStyle.w700(
                            color: AppColors.black, fontSize: 18))),
                    DataCell(Text(
                        data['paymentId'].isNotEmpty
                            ? data['paymentId']
                            : 'N/A',
                        style: AppTextStyle.w700(
                            color: AppColors.black, fontSize: 18))),
                    DataCell(Text('\₹${data['amount']}',
                        style: AppTextStyle.w700(
                            color: AppColors.black, fontSize: 18))),
                  ]);
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}
