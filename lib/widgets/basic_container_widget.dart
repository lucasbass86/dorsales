import 'package:flutter/material.dart';

class BasicContainerWidget extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color backColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Widget child;
  final double? width;
  final double? height;
  const BasicContainerWidget(
      {this.backColor = Colors.transparent,
      required this.borderColor,
      required this.borderWidth,
      required this.borderRadius,
      required this.child,
      this.padding,
      this.width,
      this.height,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWidth)),
      child: child,
    );
  }
}
