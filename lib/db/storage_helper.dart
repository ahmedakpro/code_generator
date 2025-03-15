import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; //
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/qr_code.dart';
import '../widgets/my_dialogs.dart';

class ItemStorage {
  static const _key = 'items';

  // Get all items
  static Future<List<Items>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? itemsString = prefs.getStringList(_key);
    return itemsString
            ?.map((str) => Items.fromMap(json.decode(str)))
            .toList() ??
        [];
  }

  // Save all items
  static Future<void> saveItems(List<Items> items) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsString = items.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList(_key, itemsString);
  }

  // Delete single item by ID
  static Future<bool> deleteItem(int itemNum) async {
    final items = await getItems();
    final newList = items.where((item) => item.number != itemNum).toList();
    await saveItems(newList);
    return true;
  }

  // Create backup
  static Future<String> createPersistentBackup(BuildContext cx) async {
    try {
      final currentDate = DateTime.now().toIso8601String().replaceAll(':', '-');
      await requestBackupPermissions();

      // Get items data
      final items = await getItems();
      final jsonData = json.encode(items.map((item) => item.toMap()).toList());

      // Get backup directory
      final backupDirectory = await getBackupDirectory();
      final backupDir = Directory('$backupDirectory/code_generator_Backups');
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Create backup file
      final backupFilePath =
          '${backupDir.path}/code_generator_$currentDate.json';
      final file = File(backupFilePath);
      await file.writeAsString(jsonData);

      MyDialogs.showSnackBar(
          cx, 'تم انشاء قاعدة بيانات بنجاح: $backupFilePath');

      return backupFilePath;
    } catch (e) {
      MyDialogs.showSnackBar(
          cx, 'حدث خطأ عند إنشاء قاعدة البيانات: ${e.toString()}');

      throw Exception('Backup failed: ${e.toString()}');
    }
  }

  // Restore backup
  static Future<void> restorePersistentBackup(BuildContext cx) async {
    await requestBackupPermissions();

    try {
      final backupDirectory = await getBackupDirectory();
      final backupDir = Directory('$backupDirectory/code_generator_Backups');

      if (!await backupDir.exists()) {
        MyDialogs.showSnackBar(cx, 'لا يوجد ملفات لإستعادتها');
        return;
      }

      // Get all JSON backup files
      final List<FileSystemEntity> backupFiles = backupDir
          .listSync()
          .where((file) => file.path.endsWith('.json'))
          .toList();

      if (backupFiles.isEmpty) {
        MyDialogs.showSnackBar(cx, 'لم يتم العثور على مسار النسخة الاحتياطية.');
        return;
      }

      // Sort by modified date (newest first)
      backupFiles.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      // Get latest backup
      final File latestBackup = backupFiles.first as File;
      final jsonData = await latestBackup.readAsString();
      final List<dynamic> decoded = json.decode(jsonData);

      // Clear existing data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);

      // Restore items
      final items = decoded.map((map) => Items.fromMap(map)).toList();
      await saveItems(items);

      MyDialogs.showSnackBar(
          cx, 'تم إستعادة قاعدة البيانات بنجاح المسار: ${latestBackup.path}');
    } catch (e) {
      MyDialogs.showSnackBar(cx, 'Error when restore db$e');
    }
  }

  static Future<String> getBackupDirectory() async {
    if (Platform.isAndroid) {
      if (Platform.version.contains('10')) {
        return (await getExternalStorageDirectory())!.path;
      } else {
        return '/storage/emulated/0';
      }
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
  }

  static Future<void> requestBackupPermissions() async {
    if (Platform.isAndroid) {
      var storageStatus = await Permission.storage.request();
      if (storageStatus.isGranted) {
        var manageStatus = await Permission.manageExternalStorage.request();
        if (!manageStatus.isGranted) {}
      } else {}
    }
  }
}
