import 'package:code_generator/widgets/my_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:code_generator/models/qr_code.dart';
import '../db/storage_helper.dart';
import '../screens/add_item.dart';
import '../widgets/myText.dart';

class ItemTile extends StatelessWidget {
  final Items items;
  final VoidCallback onItemDeleted;
  const ItemTile({super.key, required this.items, required this.onItemDeleted});

  @override
  Widget build(BuildContext context) {
    final GlobalKey repaintKey = GlobalKey();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          child: Card(
            shadowColor: Theme.of(context).colorScheme.onSurface,
            surfaceTintColor: Theme.of(context).colorScheme.onSurface,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(txt: items.name),
                      Row(
                        children: [
                          IconButton(
                              padding: const EdgeInsets.only(top: 20),
                              onPressed: () => MyDialogs.tasksDialog(
                                  context: context,
                                  onPressed: () async {
                                    await ItemStorage.deleteItem(items.number);
                                    Navigator.pop(context);
                                    onItemDeleted();
                                  }),
                              icon: const Icon(
                                Icons.delete,
                                size: 30,
                              )),
                          IconButton(
                              padding: const EdgeInsets.only(top: 20),
                              icon: const Icon(
                                Icons.qr_code_scanner,
                                size: 30,
                              ),
                              onPressed: () => MyDialogs.saveDailog(
                                    cnx: context,
                                    globalKey: repaintKey,
                                    itemName: items.name,
                                    itemNum: items.number,
                                    itemType: items.type,
                                    isQr: false,
                                  )),
                        ],
                      ),
                    ],
                  ),
                  MyText(
                    txt: items.type,
                  ),
                ],
              ),
            ),
          ),
          onTap: () => showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding: const EdgeInsets.all(16.0),
                child: AddItem(item: items),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
