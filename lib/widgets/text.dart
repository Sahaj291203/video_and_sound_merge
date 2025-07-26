import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final Color? textDecorationColor;
  TextAlign? textAlign;
  TextOverflow? overflow;
  final int? maxLine;
  CustomText({
    super.key,
    required this.text,
    this.size = 15,
    this.color,
    this.fontWeight,
    this.textDecoration,
    this.textDecorationColor,
    this.textAlign,
    this.overflow,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLine,
      style: TextStyle(
        fontSize: size,
        color: color ?? Theme.of(context).colorScheme.secondary,
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: textDecoration,
        decorationColor:
            textDecorationColor ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
