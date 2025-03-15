import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'myText.dart';

class MyCustomBtn extends StatelessWidget {
  final String btnText;
  final void Function()? onTap;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? color;
  const MyCustomBtn({
    super.key,
    required this.btnText,
    this.width,
    this.onTap,
    this.height,
    this.fontSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: SizedBox(
        width: width ?? 100.0,
        height: height ?? 50.0,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color ?? colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: MyText(
              txt: btnText,
              textAlign: TextAlign.center,
              family: boldFont,
              color: colorScheme.surface,
              size: fontSize ?? 20,
            ),
          ),
        ),
      ),
    );
  }
}
