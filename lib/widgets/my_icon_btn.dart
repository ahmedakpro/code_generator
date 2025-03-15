import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? iconData;
  final String? txt;
  final double? width;
  final double? height;
  final double? iconSize;
  final Color? color;
  final bool? isRegist;
  final String? tooltip;
  const MyIconButton({
    super.key,
    this.onPressed,
    this.iconData,
    this.txt,
    this.width,
    this.iconSize,
    this.color,
    this.isRegist,
    this.tooltip,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 4),
            width: width ?? 40,
            height: height ?? 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: color ?? Theme.of(context).colorScheme.surface,
            ),
            child: IconButton(
              padding: const EdgeInsets.only(left: 2),
              onPressed: onPressed,
              icon: iconData ??
                  Icon(
                    Icons.save,
                    color: Theme.of(context).colorScheme.primary,
                    size: iconSize ?? 30,
                  ),
              tooltip: tooltip,
            ),
          ),
          SizedBox(width: isRegist == true ? 0 : 5),
        ],
      ),
    );
  }
}
