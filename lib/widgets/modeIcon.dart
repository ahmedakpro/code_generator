import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/theme/theme_provider.dart';

class ModeIcon extends StatelessWidget {
  const ModeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    void themeMode() {
      Provider.of<ThemeProvider>(context, listen: false).changeTheme();
    }

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) => Container(
        padding: const EdgeInsets.only(right: 13),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: themeProvider.getTheme.brightness == Brightness.dark
              ? secondryColor
              : const Color(0xFFF3F2F2),
        ),
        child: IconButton(
          padding: const EdgeInsets.only(left: 4),
          icon: Icon(
            themeProvider.getTheme.brightness == Brightness.dark
                ? Icons.dark_mode_outlined
                : Icons.light_mode,
            size: 30,
            color: themeProvider.getTheme.brightness == Brightness.dark
                ? const Color.fromARGB(255, 254, 254, 254)
                : const Color.fromARGB(255, 43, 44, 45),
          ),
          onPressed: themeMode,
        ),
      ),
    );
  }
}
