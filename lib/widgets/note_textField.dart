import 'package:code_generator/constants/colors.dart';
import 'package:flutter/material.dart';

import 'myText.dart';

class NoteTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String txt;
  final double? height;
  const NoteTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.txt,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              child: MyText(
                txt: txt,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
                lines: 3,
              ),
            ),
            Container(
              height: height,
              width: MediaQuery.sizeOf(context).width / 1.1,
              padding: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: hintText,
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
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: regularFont,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ));
  }
}
