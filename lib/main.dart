import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants/theme/theme_provider.dart';
import 'services/providers/code_type.dart';
import 'widgets/nav_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Permission.storage.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CodeTypeProvider()),
      ],
      child: const AppWrapper(),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: themeProvider.getTheme,
      home: const BottomNavBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
