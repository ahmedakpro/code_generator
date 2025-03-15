import 'package:flutter/material.dart';

import '../db/storage_helper.dart';
import '../models/qr_code.dart';
import '../models/queue_services.dart';
import '../widgets/my_dialogs.dart';

class SaveItem {
  Future<void> saveItem({
    required String itemType,
    required String itemName,
    required bool isEditing,
    required String qrName,
    required int? itemId,
    required BuildContext cnx,
  }) async {
    if (itemName.isEmpty || itemType.isEmpty) {
      // Show error
      return;
    }
    int currentQueueNumber = 0;
    final number = int.tryParse(qrName);
    if (number == null) {
      // Show error
      return;
    }
    final QueueServices queueServices = QueueServices(
      currentQueueNumber: currentQueueNumber,
      lastQueueNum: 'lastQueueNumber',
    );
    await queueServices.initializeQueueNumber();
    final queueNumber = await queueServices.getNextQueueNumber();

    final newItem = Items(
      id: itemId ?? queueNumber,
      name: itemName,
      type: itemType,
      number: number,
    );

    final items = await ItemStorage.getItems();
    if (isEditing) {
      final index = items.indexWhere((item) => item.id == newItem.id);
      if (index != -1) items[index] = newItem;
    } else {
      items.add(newItem);
    }

    await ItemStorage.saveItems(items);
    MyDialogs.showSnackBar(
        cnx, isEditing ? 'تم التحديث بنجاح' : 'تم الحفظ بنجاح');
  }
}
