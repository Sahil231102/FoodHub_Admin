import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/home/add_item_screen.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';

import '../../const/Images.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              accountName: Text(
                "Food Hub",
                style: AppTextStyle.w600(fontSize: 20),
              ),
              accountEmail: Text(
                "admin@gmail.com",
                style: AppTextStyle.w600(
                  fontSize: 18,
                ),
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.black,
                    image: DecorationImage(
                        image: AssetImage(
                          AppImages.logo,
                        ),
                        scale: 4)),
              )),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(
              'Dashboard',
              style: AppTextStyle.w700(fontSize: 16),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
            ),
            title: Text(
              'Profile',
              style: AppTextStyle.w700(fontSize: 16),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(
              'Add Item',
              style: AppTextStyle.w700(fontSize: 16),
            ),
            onTap: () {
              Get.to(() => AddItemScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.fastfood_outlined),
            title: Text(
              'Show Item',
              style: AppTextStyle.w700(fontSize: 16),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.person_2_sharp,
            ),
            title: Text(
              'User Information',
              style: AppTextStyle.w700(fontSize: 16),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.food_bank,
            ),
            title: Text(
              'Order',
              style: AppTextStyle.w700(fontSize: 16),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.money,
            ),
            title: Text(
              'Payment',
              style: AppTextStyle.w700(fontSize: 16),
            ),
            onTap: () {},
          ),
          220.sizeHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.power_settings_new,
                        color: AppColors.white,
                      ),
                      8.sizeWidth,
                      Text(
                        "Login",
                        style: AppTextStyle.w700(
                            color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
