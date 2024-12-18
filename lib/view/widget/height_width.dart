import 'package:flutter/material.dart';

extension HeightWidthExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double widthPercentage(double percentage) => screenWidth * (percentage / 100);

  double heightPercentage(double percentage) =>
      screenHeight * (percentage / 100);
}
