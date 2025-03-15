import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String txt;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final String? family;
  final int? lines;
  final double? height;
  final int? maxLine;
  const MyText(
      {super.key,
      required this.txt,
      this.color,
      this.fontWeight,
      this.size,
      this.textAlign,
      this.family,
      this.lines,
      this.height,
      this.maxLine});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Text(
        textAlign: textAlign,
        maxLines: maxLine ?? 2,
        txt,
        style: TextStyle(
          height: height,
          fontFamily: family ?? 'Cairo',
          color: color,
          fontWeight: fontWeight,
          fontSize: size,
        ),
      ),
    );
  }
}
