import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:code_generator/constants/colors.dart';

import '../screens/about.dart';
import '../screens/add_item.dart';
import '../screens/items_list.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex = 1;
  bool ishome = true;
  final List<Widget> _pages = [
    const AddItem(qrGenerate: true),
    const AddItem(),
    const ItemsList(),
    const AboutScreen(),
  ];

  CrystalNavigationBarItem barItems(IconData icon) {
    return CrystalNavigationBarItem(
      selectedColor: primaryColor,
      unselectedColor: const Color(0xFF98A0AB),
      icon: icon,
      // title: MyText(txt: txt, family: 'Cairo-Bold'),
    );
  }

  bool isVerify = false;
  bool isEmailVerified = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _pages.isNotEmpty ? _pages[_currentIndex] : const SizedBox(),
        bottomNavigationBar: CrystalNavigationBar(
          backgroundColor: const Color(0xFFF3F2F2),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            barItems(FontAwesomeIcons.qrcode),
            barItems(FontAwesomeIcons.houseUser),
            barItems(FontAwesomeIcons.list),
            barItems(FontAwesomeIcons.circleInfo),
          ],
        ),
      ),
    );
  }
}
