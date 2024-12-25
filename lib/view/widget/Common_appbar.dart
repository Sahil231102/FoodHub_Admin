import 'package:flutter/material.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const CommonAppbar({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: AppTextStyle.w700(fontSize: 18),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
