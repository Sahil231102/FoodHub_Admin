import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/widget/height_width.dart';

class CommonButton extends StatefulWidget {
  final double? height;
  final double? width;
  final String? text;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final Color? color;
  final Color? shadowColor;
  final double borderRadius;

  const CommonButton({
    super.key,
    this.height,
    this.width,
    this.text = 'Button',
    this.onTap,
    this.textStyle,
    this.color,
    this.shadowColor,
    this.borderRadius = 35.0,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: context.heightPercentage(widget.height ?? 8),
        width: context.widthPercentage(widget.width ?? 50),
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.primary,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor ?? Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text!,
          style: widget.textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
