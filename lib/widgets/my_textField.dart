import 'package:flutter/material.dart';
import 'myText.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? txt;
  final double? maxWidth;
  final bool? enabled;
  final double? width;
  final double? height;
  final Color? color;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final double? textWidth;
  final int? maxLines;
  final EdgeInsetsGeometry? padding;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final EdgeInsets? contentPadding;
  final double? rightPadding;
  final double? topPadding;

  const MyTextField({
    super.key,
    required this.controller,
    this.txt,
    this.maxWidth,
    this.enabled,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.width,
    this.padding,
    this.color,
    this.labelText,
    this.prefixIcon,
    this.height,
    this.textWidth,
    this.maxLines,
    this.contentPadding,
    this.rightPadding,
    this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 12),
                alignment: Alignment.centerRight,
                width: textWidth,
                child: MyText(
                  txt: txt ?? '',
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                  lines: 3,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                height: height ?? 60,
                width: width ?? MediaQuery.sizeOf(context).width / 1.1,
                padding: EdgeInsets.only(
                    top: topPadding ?? 15, right: rightPadding ?? 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: TextField(
                    maxLines: maxLines ?? 2,
                    keyboardType: TextInputType.multiline,
                    onChanged: onChanged,
                    controller: controller,
                    enabled: enabled,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    decoration: InputDecoration(
                      contentPadding: contentPadding,
                      prefixIcon: prefixIcon,
                      hintText: hintText ?? txt,
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: const TextStyle(
                        color: Color(0xFF858585),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      // Remove other borders
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
